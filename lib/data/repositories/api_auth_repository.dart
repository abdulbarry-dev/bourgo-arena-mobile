import 'dart:developer' as developer;
import 'dart:async';
import 'package:bourgo_arena_mobile/core/utils/device_identity_storage.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_error_handler.dart';
import 'package:bourgo_arena_mobile/data/api/api_exceptions.dart';
import 'package:bourgo_arena_mobile/data/mappers/user_mapper.dart';
import 'package:bourgo_arena_mobile/data/mappers/verification_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/member_tier_model.dart';
import 'package:bourgo_arena_mobile/data/models/user_profile_model.dart';
import 'package:bourgo_arena_mobile/data/models/verification_status_model.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_session.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_state.dart';
import 'package:bourgo_arena_mobile/domain/entities/otp_delivery_method.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/entities/verification_status.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/device_registration_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';

/// Laravel API implementation of [AuthRepository].
class ApiAuthRepository implements AuthRepository {
  final ApiClient _apiClient;
  final SessionRepository _sessionRepository;
  final DeviceIdentityStorage _deviceIdentityStorage;
  final DeviceRegistrationRepository _deviceRegistrationRepo;
  AuthSession? _currentSession;
  final StreamController<AuthSession> _authStateController =
      StreamController<AuthSession>.broadcast();

  ApiAuthRepository(
    this._apiClient,
    this._sessionRepository,
    this._deviceIdentityStorage,
    this._deviceRegistrationRepo,
  ) {
    _apiClient.onAuthError = (String? state) {
      _handleAuthError(state, null);
    };
  }

  Future<void> _handleAuthError(String? state, String? message) async {
    developer.log('Handling auth error: state=$state, message=$message');
    // Don't re-check verification status if we're already in a pending state
    // (pending onboarding, verification, or additional verification).
    // These states should be preserved and not overridden by error handling.
    if (_currentSession != null &&
        (_currentSession!.state == AuthState.pendingOnboarding ||
            _currentSession!.state == AuthState.pendingVerification ||
            _currentSession!.state ==
                AuthState.pendingAdditionalVerification)) {
      developer.log(
        'Already in pending state (${_currentSession!.state}), skipping error verification check',
      );
      return;
    }

    // If state is not provided, try to re-fetch verification status to see if it's an onboarding/verification issue
    if (state == null) {
      final tokenResult = await _sessionRepository.getAuthToken();
      final hasToken = tokenResult.fold(
        onSuccess: (token) => token != null && token.isNotEmpty,
        onFailure: (_) => false,
      );

      if (!hasToken) {
        developer.log('No token present, clearing session directly.');
        _apiClient.setToken(null);
        await _sessionRepository.clearSession();
        if (_currentSession != null) {
          _currentSession = null;
          _authStateController.add(AuthSession.unauthenticated());
        }
        return;
      }

      developer.log('State is null, fetching verification status...');
      final statusResult = await getVerificationStatus();
      statusResult.fold(
        onSuccess: (status) {
          developer.log(
            'Verification status: ${status.isFullyVerified ? 'Verified' : 'Unverified'}, method: ${status.unverifiedMethod}',
          );

          // Never downgrade an already-authenticated session. A transient
          // 401 on an unrelated endpoint must not change the user's auth
          // state to pending verification/onboarding — the token is valid.
          if (_currentSession?.state == AuthState.authenticated) {
            developer.log(
              'Session is already authenticated — keeping current state.',
            );
            return;
          }

          if (!status.isFullyVerified) {
            if (_currentSession != null) {
              _updateSession(
                _currentSession!.copyWith(state: AuthState.pendingVerification),
              );
            } else {
              _updateSession(
                const AuthSession(state: AuthState.pendingVerification),
              );
            }
          } else {
            // If fully verified but still 403, it might be an onboarding issue
            if (_currentSession != null) {
              _updateSession(
                _currentSession!.copyWith(state: AuthState.pendingOnboarding),
              );
            } else {
              _updateSession(
                const AuthSession(state: AuthState.pendingOnboarding),
              );
            }
          }
        },
        onFailure: (failure) {
          final shouldWipe = _currentSession == null ||
              _currentSession!.state != AuthState.authenticated;
          if (shouldWipe) {
            _apiClient.setToken(null);
            _sessionRepository.clearSession();
            if (_currentSession != null) {
              _currentSession = null;
              _authStateController.add(AuthSession.unauthenticated());
            }
          }
        },
      );
    } else {
      final authState = _mapBackendState(state);

      if (_currentSession?.state == AuthState.authenticated &&
          authState != AuthState.authenticated) {
        developer.log(
          'Session is already authenticated — keeping current state.',
        );
        return;
      }

      if (_currentSession != null && _currentSession!.state != authState) {
        _updateSession(_currentSession!.copyWith(state: authState));
      } else if (_currentSession == null) {
        if (authState != AuthState.unauthenticated) {
          _updateSession(AuthSession(state: authState));
        }
      }
    }
  }

  // Update the onAuthError callback to use _handleAuthError
  // ApiAuthRepository constructor:
  // _apiClient.onAuthError = (String? state) => _handleAuthError(state, null);
  // (Wait, onAuthError doesn't pass message, so just state)

  Future<void> _updateSession(AuthSession session) async {
    developer.log(
      'ApiAuthRepository._updateSession: state=${session.state}, token=${session.token}, user=${session.user}',
    );
    _currentSession = session;
    if (session.token != null) {
      _apiClient.setToken(session.token);
      await _sessionRepository.saveAuthToken(session.token!);
    }
    await _sessionRepository.saveAuthState(session.state.name);
    _authStateController.add(session);
  }

  Future<String?> _currentUserIdentifier() async {
    final user = _currentSession?.user;
    final email = user?.email.trim();
    if (email != null && email.isNotEmpty) {
      return email;
    }

    final phone = user?.phone?.trim();
    if (phone != null && phone.isNotEmpty) {
      return phone;
    }

    try {
      final userResponse =
          await _apiClient.get('/member/profile', skipAuthError: true)
              as Map<String, dynamic>;
      final userModel = UserProfileModel.fromJson(userResponse);
      final profileUser = UserMapper.toEntity(userModel);
      final profileEmail = profileUser.email.trim();
      if (profileEmail.isNotEmpty) {
        return profileEmail;
      }

      final profilePhone = profileUser.phone?.trim();
      if (profilePhone != null && profilePhone.isNotEmpty) {
        return profilePhone;
      }
    } catch (e) {
      developer.log('Failed to resolve account identifier for deletion: $e');
    }

    return null;
  }

  Future<void> _ensureApiTokenFromSession() async {
    final tokenResult = await _sessionRepository.getAuthToken();
    tokenResult.when(
      success: (token) {
        if (token != null && token.isNotEmpty) {
          _apiClient.setToken(token);
        }
      },
      failure: (_) {},
    );
  }

  AuthState _mapBackendState(String? state) {
    switch (state) {
      case 'pending_verification':
        return AuthState.pendingVerification;
      case 'pending_deletion_cancellation':
        return AuthState.pendingDeletionCancellation;
      case 'pending_additional_verification':
        return AuthState.pendingAdditionalVerification;
      case 'pending_onboarding':
        return AuthState.pendingOnboarding;
      case 'active':
        return AuthState.authenticated;
      default:
        return AuthState.unauthenticated;
    }
  }

  bool _hasCompleteOnboardingProfile(User? user) {
    if (user == null) return false;

    return user.firstName.trim().isNotEmpty &&
        user.lastName.trim().isNotEmpty &&
        user.birthDate != null &&
        (user.gender?.trim().isNotEmpty ?? false);
  }

  Future<User?> _fetchUserProfileEntity() async {
    final userResponse =
        await _apiClient.get('/member/profile', skipAuthError: true)
            as Map<String, dynamic>;
    final userModel = UserProfileModel.fromJson(userResponse);
    return UserMapper.toEntity(userModel);
  }

  @override
  Future<Result<AuthSession, Failure>> login(
    String identifier,
    String password,
  ) async {
    final result = await executeApiCall(() async {
      // Clear any existing token before login to avoid interference
      _apiClient.setToken(null);

      final isEmail = identifier.contains('@');
      final deviceId = _deviceIdentityStorage.getDeviceId();
      final response =
          await _apiClient.post('/auth/login', {
                isEmail ? 'email' : 'phone': identifier,
                'password': password,
                if (deviceId != null) 'device_id': deviceId,
              })
              as Map<String, dynamic>;

      // Support responses that wrap payload in a `data` object (backend may return
      // `{ success: true, message: '', data: { token, state } }`). Prefer top-level
      // values but fall back to `data` if present.
      Map<String, dynamic>? payload = response;
      if (response['data'] is Map<String, dynamic>) {
        payload = response['data'] as Map<String, dynamic>;
      }

      final token = payload['token'] as String? ?? response['token'] as String?;
      final stateStr =
          payload['state'] as String? ?? response['state'] as String?;
      final state = _mapBackendState(stateStr);

      VerificationData? verificationData;
      if (payload['verification_status'] != null) {
        final status = payload['verification_status'] as Map<String, dynamic>;
        verificationData = VerificationData(
          unverifiedMethod: status['unverified_method'] ?? 'phone',
          email: status['email'],
          phone: status['phone'],
          onboardingCompleted: status['onboarding_completed'] as bool?,
        );
      } else if (response['verification_status'] != null) {
        final status = response['verification_status'] as Map<String, dynamic>;
        verificationData = VerificationData(
          unverifiedMethod: status['unverified_method'] ?? 'phone',
          email: status['email'],
          phone: status['phone'],
          onboardingCompleted: status['onboarding_completed'] as bool?,
        );
      }

      await _sessionRepository.saveAuthState(state.name);

      if (state == AuthState.pendingVerification && isEmail) {
        await _sessionRepository.savePendingVerificationEmail(identifier);
      }

      User? user;
      AuthState finalState = state;
      final userData =
          payload['user'] ?? response['user'] ?? response['member'];

      if (userData != null) {
        final userModel = UserProfileModel.fromJson(
          userData as Map<String, dynamic>,
        );
        user = UserMapper.toEntity(userModel);
      }

      final shouldRefreshProfile =
          token != null &&
          (user == null ||
              (finalState == AuthState.pendingOnboarding &&
                  !_hasCompleteOnboardingProfile(user)));

      if (shouldRefreshProfile) {
        // If a token was provided but user data is missing, attempt to fetch
        // the profile. This also normalizes partial onboarding sessions where
        // the backend returns only contact information.
        try {
          user = await _fetchUserProfileEntity();
        } catch (e) {
          developer.log(
            'Profile fetch failed during login while token present. Error: $e',
          );
          // If the backend indicated pending additional verification but the
          // profile is not retrievable, treat it as pending onboarding so the
          // UI can route the user to complete onboarding instead of waiting
          // for additional verification.
          if (finalState == AuthState.pendingAdditionalVerification) {
            finalState = AuthState.pendingOnboarding;
          }
        }
      }

      final session = AuthSession(
        user: user,
        state: finalState,
        token: token,
        verificationData: verificationData,
      );

      final finalSession = await _checkLoginVerification(session);
      await _updateSession(finalSession);

      // Await device linking to ensure subsequent requests are authenticated
      await _linkDeviceAfterAuth(deviceId);

      return Success(finalSession);
    });

    // If the API call failed but returned a state (e.g. pending_onboarding),
    // we handle it as a partial success to allow redirection.
    if (result is FailureResult<AuthSession, Failure>) {
      final failure = result.failure;
      if (failure.state != null) {
        final state = _mapBackendState(failure.state);

        if (failure.token != null) {
          _apiClient.setToken(failure.token);
          await _sessionRepository.saveAuthToken(failure.token!);
          await _sessionRepository.saveAuthState(state.name);

          // Try to fetch user profile to populate the session
          try {
            final userResponse =
                await _apiClient.get('/member/profile', skipAuthError: true)
                    as Map<String, dynamic>;
            final userModel = UserProfileModel.fromJson(userResponse);
            final user = UserMapper.toEntity(userModel);

            final session = AuthSession(
              user: user,
              state: state,
              token: failure.token,
            );
            final finalSession = await _checkLoginVerification(session);
            await _updateSession(finalSession);
            return Success(finalSession);
          } catch (_) {
            // If profile fetch fails, continue with state only
          }
        }

        final session = AuthSession(state: state, token: failure.token);
        await _updateSession(session);
        return Success(session);
      }
    }

    return result;
  }

  Future<AuthSession> _checkLoginVerification(AuthSession session) async {
    // We only prompt for second OTP if the user is already "authenticated" (active)
    // and fully onboarded (PIN set).
    if (session.state == AuthState.authenticated && session.user != null) {
      final skipForeverResult = await _sessionRepository
          .shouldSkipLoginOtpForever();
      final skipForever = skipForeverResult.fold(
        onSuccess: (val) => val,
        onFailure: (_) => false,
      );

      if (!skipForever) {
        final statusResult = await getVerificationStatus();
        return statusResult.fold(
          onSuccess: (status) {
            // If not fully verified, mark as needing login verification
            if (!status.isFullyVerified) {
              return AuthSession(
                user: session.user,
                state: AuthState.pendingAdditionalVerification,
                token: session.token,
                verificationData: VerificationData(
                  unverifiedMethod: status.unverifiedMethod ?? 'phone',
                  email: status.email,
                  phone: status.phone,
                  onboardingCompleted: status.onboardingCompleted,
                ),
                needsLoginVerification: true,
              );
            }
            return session;
          },
          onFailure: (_) => session,
        );
      }
    }
    return session;
  }

  @override
  Future<Result<void, Failure>> deleteAccount({required String password}) {
    return executeApiCall(() async {
      final identifier = await _currentUserIdentifier();
      if (identifier == null || identifier.isEmpty) {
        throw const AuthException(
          'Unable to determine the account identifier for deletion.',
        );
      }

      final rawResponse = await _apiClient.post('/auth/delete-account', {
        'identifier': identifier,
        'password': password,
      });

      final response = rawResponse is Map<String, dynamic>
          ? rawResponse
          : <String, dynamic>{};

      Map<String, dynamic> payload = response;
      if (response['data'] is Map<String, dynamic>) {
        payload = response['data'] as Map<String, dynamic>;
      }

      final stateStr =
          payload['state'] as String? ?? response['state'] as String?;
      final token = payload['token'] as String? ?? response['token'] as String?;

      if (stateStr != null) {
        final state = _mapBackendState(stateStr);

        User? user;
        final userData =
            payload['user'] ?? response['user'] ?? response['member'];
        if (userData is Map<String, dynamic>) {
          final userModel = UserProfileModel.fromJson(userData);
          user = UserMapper.toEntity(userModel);
        }

        await _sessionRepository.savePendingVerificationEmail(identifier);
        await _updateSession(
          AuthSession(
            user: user ?? _currentSession?.user,
            state: state,
            token: token ?? _currentSession?.token,
            pendingEmail: identifier,
            verificationData: _currentSession?.verificationData,
          ),
        );
      }

      return const Success(null);
    });
  }

  @override
  Future<Result<void, Failure>> logout() {
    return executeApiCall(() async {
      try {
        await _apiClient.post('/auth/logout', {});
        return const Success(null);
      } finally {
        final deviceId = _deviceIdentityStorage.getDeviceId();
        if (deviceId != null) {
          try {
            await _deviceRegistrationRepo.logout(deviceId);
          } catch (_) {}
        }
        _apiClient.setToken(null);
        // Restore device token as fallback Bearer after sanctum token cleared
        final deviceToken = _deviceIdentityStorage.getRegistrationToken();
        if (deviceToken != null) {
          _apiClient.setDeviceToken(deviceToken);
        }
        // Clear the persisted session (including the token)
        await _sessionRepository.clearSession();
        _currentSession = null;
        _authStateController.add(AuthSession.unauthenticated());
      }
    });
  }

  @override
  Future<Result<void, Failure>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required String gender,
    required DateTime birthDate,
    bool isFamilyAccount = false,
  }) {
    return executeApiCall(() async {
      // Clear any existing token to ensure registration is unauthenticated
      _apiClient.setToken(null);

      final fullName = '$firstName $lastName'.trim();
      final dateOfBirth = birthDate.toIso8601String().split('T')[0];
      final deviceId = _deviceIdentityStorage.getDeviceId();

      final rawResponse = await _apiClient.post('/auth/register', {
        'name': fullName,
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': password,
        'date_of_birth': dateOfBirth,
        'gender': gender,
        'is_parent_account': isFamilyAccount,
        if (deviceId != null) 'device_id': deviceId,
      });
      final response = rawResponse is Map<String, dynamic>
          ? rawResponse
          : <String, dynamic>{};

      Map<String, dynamic> payload = response;
      if (response['data'] is Map<String, dynamic>) {
        payload = response['data'] as Map<String, dynamic>;
      }

      final token = payload['token'] as String? ?? response['token'] as String?;
      final stateStr =
          payload['state'] as String? ??
          response['state'] as String? ??
          'pending_verification';
      final state = _mapBackendState(stateStr);

      User? user;
      final userData =
          payload['user'] ?? response['user'] ?? response['member'];
      if (userData is Map<String, dynamic>) {
        final userModel = UserProfileModel.fromJson(userData);
        user = UserMapper.toEntity(userModel);
      }

      VerificationData? verificationData;
      final statusData =
          payload['verification_status'] ?? response['verification_status'];
      if (statusData is Map<String, dynamic>) {
        verificationData = VerificationData(
          unverifiedMethod: statusData['unverified_method'] ?? 'phone',
          email: statusData['email'],
          phone: statusData['phone'],
          onboardingCompleted: statusData['onboarding_completed'] as bool?,
        );
      }

      await _sessionRepository.savePendingVerificationEmail(email);
      await _updateSession(
        AuthSession(
          user: user,
          state: state,
          token: token,
          pendingEmail: email,
          verificationData: verificationData,
        ),
      );

      await _linkDeviceAfterAuth(deviceId);

      return const Success(null);
    });
  }

  Future<void> _linkDeviceAfterAuth(String? deviceId) async {
    if (deviceId == null) return;
    try {
      await _deviceRegistrationRepo.link(deviceId);
      developer.log('Device successfully linked to member.', name: 'ApiAuthRepository');
    } catch (e) {
      developer.log('Failed to link device after auth: $e', name: 'ApiAuthRepository');
    }
  }

  @override
  Future<Result<void, Failure>> sendOtp(String identifier) {
    return executeApiCall(() async {
      await _apiClient.post('/auth/send-otp', {'identifier': identifier});
      return const Success(null);
    });
  }

  @override
  Future<Result<bool, Failure>> verifyOtp(String identifier, String otp) {
    return executeApiCall(() async {
      final response =
          await _apiClient.post('/auth/verify-otp', {
                'identifier': identifier,
                'otp': otp,
              })
              as Map<String, dynamic>;

      Map<String, dynamic> payload = response;
      if (response['data'] is Map<String, dynamic>) {
        payload = response['data'] as Map<String, dynamic>;
      }

      final isValid =
          response['valid'] == true ||
          payload['valid'] == true ||
          payload.containsKey('state') ||
          response.containsKey('state');

      if (isValid) {
        final token =
            payload['token'] as String? ??
            response['token'] as String? ??
            _currentSession?.token;
        final stateStr =
            payload['state'] as String? ?? response['state'] as String?;

        if (token != null && token.isNotEmpty && stateStr == null) {
          _apiClient.setToken(token);
          await _sessionRepository.saveAuthToken(token);
        }

        if (stateStr != null) {
          final state = _mapBackendState(stateStr);
          await _sessionRepository.saveAuthState(state.name);

          User? user;
          final userData =
              payload['user'] ??
              response['user'] ??
              payload['member'] ??
              response['member'];
          if (userData is Map<String, dynamic>) {
            final userModel = UserProfileModel.fromJson(userData);
            user = UserMapper.toEntity(userModel);
          }

          VerificationData? verificationData;
          final statusData =
              payload['verification_status'] ?? response['verification_status'];
          if (statusData is Map<String, dynamic>) {
            verificationData = VerificationData(
              unverifiedMethod: statusData['unverified_method'] ?? 'phone',
              email: statusData['email'],
              phone: statusData['phone'],
              onboardingCompleted: statusData['onboarding_completed'] as bool?,
            );
          }

          await _updateSession(
            AuthSession(
              user: user ?? _currentSession?.user,
              state: state,
              token: token,
              verificationData: verificationData,
            ),
          );
        }
      }

      return Success(isValid);
    });
  }

  @override
  Future<Result<String, Failure>> requestFamilyAccountOtp({
    OtpDeliveryMethod? method,
  }) {
    return executeApiCall(() async {
      final payload = <String, dynamic>{};
      if (method != null) {
        payload['method'] = method.value;
      }
      final response = await _apiClient.post(
        '/auth/request-family-otp',
        payload,
      );
      final message = response is Map<String, dynamic>
          ? response['message'] as String?
          : null;
      return Success(message ?? 'OTP code sent successfully.');
    });
  }

  @override
  Future<Result<void, Failure>> completeRegistration(User user) {
    return executeApiCall(() async {
      await _ensureApiTokenFromSession();

      final response =
          await _apiClient.post('/auth/complete-registration', {
                'name': '${user.firstName} ${user.lastName}',
                'email': user.email,
                'phone': user.phone,
                'date_of_birth': user.birthDate?.toIso8601String().split(
                  'T',
                )[0],
                'gender': user.gender,
                'is_parent_account': user.isParentAccount,
              })
              as Map<String, dynamic>;

      Map<String, dynamic> payload = response;
      if (response['data'] is Map<String, dynamic>) {
        payload = response['data'] as Map<String, dynamic>;
      }

      final stateStr =
          payload['state'] as String? ??
          response['state'] as String? ??
          'active';
      final state = _mapBackendState(stateStr);
      final token = payload['token'] as String? ?? response['token'] as String?;

      VerificationData? verificationData;
      final statusData =
          payload['verification_status'] ?? response['verification_status'];
      if (statusData is Map<String, dynamic>) {
        verificationData = VerificationData(
          unverifiedMethod: statusData['unverified_method'] ?? 'phone',
          email: statusData['email'],
          phone: statusData['phone'],
          onboardingCompleted: statusData['onboarding_completed'] as bool?,
        );
      }

      User updatedUser = user;
      final userData =
          payload['user'] ??
          response['user'] ??
          payload['member'] ??
          response['member'];
      if (userData is Map<String, dynamic>) {
        final userModel = UserProfileModel.fromJson(userData);
        updatedUser = UserMapper.toEntity(userModel);
      }

      if (token != null) {
        _apiClient.setToken(token);
        await _sessionRepository.saveAuthToken(token);
      }

      await _updateSession(
        AuthSession(
          user: updatedUser,
          state: state,
          token: token ?? _currentSession?.token,
          verificationData: verificationData,
        ),
      );

      final onboardingCompleted =
          verificationData?.onboardingCompleted ??
          state == AuthState.authenticated;
      await _sessionRepository.setOnboardingCompleted(onboardingCompleted);
      return const Success(null);
    });
  }

  @override
  Future<Result<void, Failure>> forgotPassword(String identifier) {
    return executeApiCall(() async {
      await _apiClient.post('/auth/forgot-password', {
        'identifier': identifier,
      });
      return const Success(null);
    });
  }

  @override
  Future<Result<void, Failure>> resetPassword({
    required String identifier,
    required String otp,
    required String newPassword,
  }) {
    return executeApiCall(() async {
      await _apiClient.post('/auth/reset-password', {
        'identifier': identifier,
        'otp': otp,
        'password': newPassword,
        'password_confirmation': newPassword,
      });
      return const Success(null);
    });
  }

  @override
  Future<Result<void, Failure>> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return executeApiCall(() async {
      await _apiClient.put('/member/password', {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPassword,
      });
      return const Success(null);
    });
  }

  @override
  Future<Result<AuthSession, Failure>> getUserProfile() async {
    if (!_apiClient.hasToken) {
      return FailureResult(
        AuthFailure(AppErrorCode.invalidCredentials, 'Guest user'),
      );
    }
    final result = await executeApiCall(() async {
      final userResponse =
          await _apiClient.get('/member/profile') as Map<String, dynamic>;

      final userModel = UserProfileModel.fromJson(userResponse);
      final user = UserMapper.toEntity(userModel);

      // Backend should ideally return state here too. If not, default to active.
      final stateStr = userResponse['state'] as String? ?? 'active';
      final state = _mapBackendState(stateStr);

      await _sessionRepository.saveAuthState(state.name);

      final tokenResult = await _sessionRepository.getAuthToken();
      final token = tokenResult.fold(
        onSuccess: (t) => t,
        onFailure: (_) => null,
      );

      final session = AuthSession(user: user, state: state, token: token);
      final finalSession = await _checkLoginVerification(session);
      await _updateSession(finalSession);
      return Success(finalSession);
    });

    if (result is FailureResult<AuthSession, Failure>) {
      if (result.failure is AuthFailure) {
        developer.log(
          'getUserProfile failed with AuthFailure: ${result.failure.message}',
        );
        // Only wipe the session if we are not already authenticated.
        // A transient AuthFailure on a subsequent profile fetch should not
        // log out an active user — the existing token may still be valid.
        if (_currentSession == null ||
            _currentSession!.state != AuthState.authenticated) {
          _apiClient.setToken(null);
          await _sessionRepository.clearSession();
          _authStateController.add(AuthSession.unauthenticated());
        }
      } else {
        developer.log(
          'getUserProfile failed with: ${result.failure.runtimeType}, ${result.failure.message}',
        );
      }
    }

    return result;
  }

  @override
  Future<Result<AuthSession, Failure>> uploadAvatar(String filePath) async {
    if (!_apiClient.hasToken) {
      return FailureResult(
        AuthFailure(AppErrorCode.invalidCredentials, 'Guest user'),
      );
    }
    return executeApiCall(() async {
      final userResponse =
          await _apiClient.uploadMultipart(
                '/member/profile/avatar',
                fileFieldName: 'avatar',
                filePath: filePath,
              )
              as Map<String, dynamic>;

      final userModel = UserProfileModel.fromJson(userResponse);
      final user = UserMapper.toEntity(userModel);

      final stateStr = userResponse['state'] as String? ?? 'active';
      final state = _mapBackendState(stateStr);

      await _sessionRepository.saveAuthState(state.name);

      final tokenResult = await _sessionRepository.getAuthToken();
      final token = tokenResult.fold(
        onSuccess: (t) => t,
        onFailure: (_) => null,
      );

      final session = AuthSession(user: user, state: state, token: token);
      final finalSession = await _checkLoginVerification(session);
      await _updateSession(finalSession);
      return Success(finalSession);
    });
  }

  @override
  Future<Result<AuthSession, Failure>> deleteAvatar() async {
    if (!_apiClient.hasToken) {
      return FailureResult(
        AuthFailure(AppErrorCode.invalidCredentials, 'Guest user'),
      );
    }
    return executeApiCall(() async {
      final userResponse =
          await _apiClient.delete('/member/profile/avatar')
              as Map<String, dynamic>;

      final userModel = UserProfileModel.fromJson(userResponse);
      final user = UserMapper.toEntity(userModel);

      final stateStr = userResponse['state'] as String? ?? 'active';
      final state = _mapBackendState(stateStr);

      await _sessionRepository.saveAuthState(state.name);

      final tokenResult = await _sessionRepository.getAuthToken();
      final token = tokenResult.fold(
        onSuccess: (t) => t,
        onFailure: (_) => null,
      );

      final session = AuthSession(user: user, state: state, token: token);
      final finalSession = await _checkLoginVerification(session);
      await _updateSession(finalSession);
      return Success(finalSession);
    });
  }

  @override
  Future<Result<AuthSession, Failure>> getMemberTier() async {
    if (!_apiClient.hasToken) {
      return FailureResult(
        AuthFailure(AppErrorCode.invalidCredentials, 'Guest user'),
      );
    }
    return executeApiCall(() async {
      final tierResponse =
          await _apiClient.get('/member/tier') as Map<String, dynamic>;

      final tierModel = MemberTierModel.fromJson(tierResponse);
      final currentUser = _currentSession?.user;
      if (currentUser == null) {
        throw ServerException('No profile loaded. Fetch profile before tier.');
      }

      final updatedUser = currentUser.copyWith(
        subscriptionLevel: tierModel.label,
      );

      final state = _currentSession!.state;
      final token = _currentSession!.token;

      final session = AuthSession(
        user: updatedUser,
        state: state,
        token: token,
      );
      await _updateSession(session);
      return Success(session);
    });
  }

  @override
  Future<Result<String?, Failure>> getToken() async {
    // Retrieve the persisted auth token from local session storage
    return _sessionRepository.getAuthToken();
  }

  @override
  Future<Result<VerificationStatus, Failure>> getVerificationStatus() {
    if (!_apiClient.hasToken) {
      return Future.value(
        FailureResult(
          AuthFailure(AppErrorCode.invalidCredentials, 'Guest user'),
        ),
      );
    }
    return executeApiCall(() async {
      final response =
          await _apiClient.get(
                '/user/verification-status',
                skipAuthError: true,
              )
              as Map<String, dynamic>;
      final model = VerificationStatusModel.fromJson(response);
      final status = VerificationMapper.toEntity(model);
      return Success(status);
    });
  }

  @override
  Future<Result<bool, Failure>> verifyEmail(String email, String otp) {
    return executeApiCall(() async {
      final response =
          await _apiClient.post('/member/verify-email', {
                'email': email,
                'otp': otp,
              })
              as Map<String, dynamic>;

      Map<String, dynamic> payload = response;
      if (response['data'] is Map<String, dynamic>) {
        payload = response['data'] as Map<String, dynamic>;
      }

      final isValid =
          response['valid'] == true ||
          payload['valid'] == true ||
          payload.containsKey('state') ||
          response.containsKey('state');

      if (isValid) {
        final token =
            payload['token'] as String? ??
            response['token'] as String? ??
            _currentSession?.token;
        final stateStr =
            payload['state'] as String? ?? response['state'] as String?;

        if (token != null && token.isNotEmpty && stateStr == null) {
          _apiClient.setToken(token);
          await _sessionRepository.saveAuthToken(token);
        }

        if (stateStr != null) {
          final state = _mapBackendState(stateStr);
          await _sessionRepository.saveAuthState(state.name);

          User? user;
          final userData =
              payload['user'] ??
              response['user'] ??
              payload['member'] ??
              response['member'];
          if (userData is Map<String, dynamic>) {
            final userModel = UserProfileModel.fromJson(userData);
            user = UserMapper.toEntity(userModel);
          }

          await _updateSession(
            AuthSession(
              user: user ?? _currentSession?.user,
              state: state,
              token: token,
            ),
          );
        }
      }

      return Success(isValid);
    });
  }

  @override
  Future<Result<bool, Failure>> verifyPhone(String phone, String otp) {
    return executeApiCall(() async {
      final response =
          await _apiClient.post('/member/verify-phone', {
                'phone': phone,
                'otp': otp,
              })
              as Map<String, dynamic>;

      Map<String, dynamic> payload = response;
      if (response['data'] is Map<String, dynamic>) {
        payload = response['data'] as Map<String, dynamic>;
      }

      final isValid =
          response['valid'] == true ||
          payload['valid'] == true ||
          payload.containsKey('state') ||
          response.containsKey('state');

      if (isValid) {
        final token =
            payload['token'] as String? ??
            response['token'] as String? ??
            _currentSession?.token;
        final stateStr =
            payload['state'] as String? ?? response['state'] as String?;

        if (token != null && token.isNotEmpty && stateStr == null) {
          _apiClient.setToken(token);
          await _sessionRepository.saveAuthToken(token);
        }

        if (stateStr != null) {
          final state = _mapBackendState(stateStr);
          await _sessionRepository.saveAuthState(state.name);

          User? user;
          final userData =
              payload['user'] ??
              response['user'] ??
              payload['member'] ??
              response['member'];
          if (userData is Map<String, dynamic>) {
            final userModel = UserProfileModel.fromJson(userData);
            user = UserMapper.toEntity(userModel);
          }

          await _updateSession(
            AuthSession(
              user: user ?? _currentSession?.user,
              state: state,
              token: token,
            ),
          );
        }
      }

      return Success(isValid);
    });
  }

  @override
  Future<Result<bool, Failure>> skipAdditionalVerification() {
    return executeApiCall(() async {
      developer.log(
        'Skipping additional verification with token: ${_currentSession?.token != null ? 'Present' : 'Missing'}',
      );
      final response =
          await _apiClient.post('/auth/skip-additional-verification', {})
              as Map<String, dynamic>;

      final stateStr = response['state'] as String?;
      final token = response['token'] as String?;

      if (token != null && stateStr == null) {
        _apiClient.setToken(token);
        await _sessionRepository.saveAuthToken(token);
      }

      if (stateStr != null) {
        final state = _mapBackendState(stateStr);
        await _updateSession(
          AuthSession(
            user: _currentSession?.user,
            state: state,
            token: token ?? _currentSession?.token,
          ),
        );
      }

      return Success(true);
    });
  }

  @override
  Stream<AuthSession> get onAuthStateChanged => _authStateController.stream;
}
