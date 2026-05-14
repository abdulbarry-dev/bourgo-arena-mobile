import 'dart:async';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_error_handler.dart';
import 'package:bourgo_arena_mobile/data/mappers/user_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/user_profile_model.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_session.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_state.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/entities/verification_status.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';

/// Laravel API implementation of [AuthRepository].
class ApiAuthRepository implements AuthRepository {
  final ApiClient _apiClient;
  final SessionRepository _sessionRepository;
  final StreamController<AuthSession> _authStateController =
      StreamController<AuthSession>.broadcast();

  ApiAuthRepository(this._apiClient, this._sessionRepository);

  AuthState _mapBackendState(String? state) {
    switch (state) {
      case 'pending_verification':
        return AuthState.pendingVerification;
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

  @override
  Future<Result<AuthSession, Failure>> login(
    String identifier,
    String password,
  ) async {
    final result = await executeApiCall(() async {
      // Clear any existing token before login to avoid interference
      _apiClient.setToken(null);

      final isEmail = identifier.contains('@');
      final response =
          await _apiClient.post('/auth/login', {
                isEmail ? 'email' : 'phone': identifier,
                'password': password,
              })
              as Map<String, dynamic>;

      final token = response['token'] as String?;
      final stateStr = response['state'] as String?;
      final state = _mapBackendState(stateStr);

      if (token != null) {
        _apiClient.setToken(token);
        await _sessionRepository.saveAuthToken(token);
      }

      await _sessionRepository.saveAuthState(state.name);

      if (state == AuthState.pendingVerification && isEmail) {
        await _sessionRepository.savePendingVerificationEmail(identifier);
      }

      User? user;
      if (response['user'] != null) {
        final userModel = UserProfileModel.fromJson(
          response['user'] as Map<String, dynamic>,
        );
        user = UserMapper.toEntity(userModel);
      } else if (token != null) {
        // Fetch user profile if token exists but user data is missing
        final userResponse =
            await _apiClient.get('/user/profile') as Map<String, dynamic>;
        final userModel = UserProfileModel.fromJson(userResponse);
        user = UserMapper.toEntity(userModel);
      }

      final session = AuthSession(user: user, state: state, token: token);
      _authStateController.add(session);
      return Success(session);
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

          // Try to fetch user profile to populate the session
          try {
            final userResponse =
                await _apiClient.get('/user/profile') as Map<String, dynamic>;
            final userModel = UserProfileModel.fromJson(userResponse);
            final user = UserMapper.toEntity(userModel);

            await _sessionRepository.saveAuthState(state.name);
            final session = AuthSession(
              user: user,
              state: state,
              token: failure.token,
            );
            _authStateController.add(session);
            return Success(session);
          } catch (_) {
            // If profile fetch fails, continue with state only
          }
        }

        await _sessionRepository.saveAuthState(state.name);

        final session = AuthSession(state: state, token: failure.token);
        _authStateController.add(session);
        return Success(session);
      }
    }

    return result;
  }

  @override
  Future<Result<void, Failure>> logout() {
    return executeApiCall(() async {
      try {
        await _apiClient.post('/auth/logout', {});
        return const Success(null);
      } finally {
        _apiClient.setToken(null);
        // Clear the persisted session (including the token)
        await _sessionRepository.clearSession();
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
      await _apiClient.post('/auth/register', {
        'name': '$firstName $lastName',
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': password,
        'gender': gender,
        'date_of_birth': birthDate.toIso8601String().split('T')[0],
        'is_family_account': isFamilyAccount,
      });

      // After successful registration, the user is typically in pending_verification state.
      await _sessionRepository.saveAuthState(
        AuthState.pendingVerification.name,
      );
      await _sessionRepository.savePendingVerificationEmail(email);

      _authStateController.add(
        AuthSession(state: AuthState.pendingVerification, pendingEmail: email),
      );

      return const Success(null);
    });
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

      final isValid = response['valid'] == true;

      if (isValid) {
        final token = response['token'] as String?;
        final stateStr = response['state'] as String?;

        if (token != null) {
          _apiClient.setToken(token);
          await _sessionRepository.saveAuthToken(token);
        }

        if (stateStr != null) {
          final state = _mapBackendState(stateStr);
          await _sessionRepository.saveAuthState(state.name);

          User? user;
          if (response['user'] != null) {
            final userModel = UserProfileModel.fromJson(
              response['user'] as Map<String, dynamic>,
            );
            user = UserMapper.toEntity(userModel);
          }

          _authStateController.add(
            AuthSession(user: user, state: state, token: token),
          );
        }
      }

      return Success(isValid);
    });
  }

  @override
  Future<Result<void, Failure>> requestFamilyAccountOtp() {
    return executeApiCall(() async {
      await _apiClient.post('/auth/request-family-otp', {});
      return const Success(null);
    });
  }

  @override
  Future<Result<void, Failure>> completeRegistration(User user, String pin) {
    return executeApiCall(() async {
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
                'pin': pin,
              })
              as Map<String, dynamic>;

      // Check if a token was returned in the response
      final token = response['token'] as String?;
      if (token != null) {
        _apiClient.setToken(token);
        await _sessionRepository.saveAuthToken(token);

        // Fetch the full profile from the server to ensure we have
        // consistent data (id, roles, etc.)
        final profileResult = await getUserProfile();
        return profileResult.when(
          success: (_) => const Success(null),
          failure: (failure) => FailureResult(failure),
        );
      }

      final stateStr = response['state'] as String? ?? 'active';
      final state = _mapBackendState(stateStr);
      await _sessionRepository.saveAuthState(state.name);

      _authStateController.add(AuthSession(user: user, state: state));
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
      await _apiClient.put('/user/password', {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPassword,
      });
      return const Success(null);
    });
  }

  @override
  Future<Result<AuthSession, Failure>> getUserProfile() async {
    final result = await executeApiCall(() async {
      final userResponse =
          await _apiClient.get('/user/profile') as Map<String, dynamic>;

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
      _authStateController.add(session);
      return Success(session);
    });

    if (result is FailureResult<AuthSession, Failure>) {
      if (result.failure is AuthFailure) {
        // If profile fetch fails due to auth, clear everything
        _apiClient.setToken(null);
        await _sessionRepository.clearSession();
        _authStateController.add(AuthSession.unauthenticated());
      }
    }

    return result;
  }

  @override
  Future<Result<String?, Failure>> getToken() async {
    // Retrieve the persisted auth token from local session storage
    return _sessionRepository.getAuthToken();
  }

  @override
  Future<Result<VerificationStatus, Failure>> getVerificationStatus() {
    return executeApiCall(() async {
      final response =
          await _apiClient.get('/user/verification-status')
              as Map<String, dynamic>;
      final status = VerificationStatus.fromJson(response);
      return Success(status);
    });
  }

  @override
  Future<Result<bool, Failure>> verifyEmail(String email, String otp) {
    return executeApiCall(() async {
      final response =
          await _apiClient.post('/user/verify-email', {
                'email': email,
                'otp': otp,
              })
              as Map<String, dynamic>;

      final isValid = response['valid'] == true;

      if (isValid) {
        final token = response['token'] as String?;
        final stateStr = response['state'] as String?;

        if (token != null) {
          _apiClient.setToken(token);
          await _sessionRepository.saveAuthToken(token);
        }

        if (stateStr != null) {
          final state = _mapBackendState(stateStr);
          await _sessionRepository.saveAuthState(state.name);

          User? user;
          if (response['user'] != null) {
            final userModel = UserProfileModel.fromJson(
              response['user'] as Map<String, dynamic>,
            );
            user = UserMapper.toEntity(userModel);
          }

          _authStateController.add(
            AuthSession(user: user, state: state, token: token),
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
          await _apiClient.post('/user/verify-phone', {
                'phone': phone,
                'otp': otp,
              })
              as Map<String, dynamic>;

      final isValid = response['valid'] == true;

      if (isValid) {
        final token = response['token'] as String?;
        final stateStr = response['state'] as String?;

        if (token != null) {
          _apiClient.setToken(token);
          await _sessionRepository.saveAuthToken(token);
        }

        if (stateStr != null) {
          final state = _mapBackendState(stateStr);
          await _sessionRepository.saveAuthState(state.name);

          User? user;
          if (response['user'] != null) {
            final userModel = UserProfileModel.fromJson(
              response['user'] as Map<String, dynamic>,
            );
            user = UserMapper.toEntity(userModel);
          }

          _authStateController.add(
            AuthSession(user: user, state: state, token: token),
          );
        }
      }

      return Success(isValid);
    });
  }

  @override
  Stream<AuthSession> get onAuthStateChanged => _authStateController.stream;
}
