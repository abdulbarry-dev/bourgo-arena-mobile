import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/verification_status.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/send_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/verify_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/get_verification_status_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/request_family_account_otp_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/auth/otp/otp_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';

class MockVerifyOtpUseCase extends Mock implements VerifyOtpUseCase {}

class MockSendOtpUseCase extends Mock implements SendOtpUseCase {}

class MockGetVerificationStatusUseCase extends Mock
    implements GetVerificationStatusUseCase {}

class MockRequestFamilyAccountOtpUseCase extends Mock
    implements RequestFamilyAccountOtpUseCase {}

void main() {
  late MockVerifyOtpUseCase mockVerifyOtpUseCase;
  late MockSendOtpUseCase mockSendOtpUseCase;
  late MockGetVerificationStatusUseCase mockGetVerificationStatusUseCase;
  late MockRequestFamilyAccountOtpUseCase mockRequestFamilyAccountOtpUseCase;
  late OtpViewModel viewModel;

  setUp(() {
    mockVerifyOtpUseCase = MockVerifyOtpUseCase();
    mockSendOtpUseCase = MockSendOtpUseCase();
    mockGetVerificationStatusUseCase = MockGetVerificationStatusUseCase();
    mockRequestFamilyAccountOtpUseCase = MockRequestFamilyAccountOtpUseCase();
    viewModel = OtpViewModel(
      mockVerifyOtpUseCase,
      mockSendOtpUseCase,
      mockGetVerificationStatusUseCase,
      mockRequestFamilyAccountOtpUseCase,
    );
  });

  group('OtpViewModel -', () {
    test('verify calls VerifyOtpUseCase and triggers onSuccess', () async {
      when(
        () => mockVerifyOtpUseCase(any(), any()),
      ).thenAnswer((_) async => const Success(true));
      when(() => mockGetVerificationStatusUseCase()).thenAnswer(
        (_) async => const Success(
          VerificationStatus(
            emailVerified: true,
            phoneVerified: true,
            onboardingCompleted: true,
            isFullyVerified: true,
            email: 'test@example.com',
            phone: '+1234567890',
          ),
        ),
      );

      bool successCalled = false;
      await viewModel.verify(
        identifier: 'test@example.com',
        code: '123456',
        onSuccess: () => successCalled = true,
        onAdditionalVerificationNeeded: (method, email, phone) {},
        onOnboardingIncomplete: () {},
      );

      verify(
        () => mockVerifyOtpUseCase('test@example.com', '123456'),
      ).called(1);
      verify(() => mockGetVerificationStatusUseCase()).called(1);
      expect(successCalled, isTrue);
      expect(viewModel.isLoading, isFalse);
    });

    test(
      'verify triggers additional verification callback when needed',
      () async {
        when(
          () => mockVerifyOtpUseCase(any(), any()),
        ).thenAnswer((_) async => const Success(true));
        when(() => mockGetVerificationStatusUseCase()).thenAnswer(
          (_) async => const Success(
            VerificationStatus(
              emailVerified: false,
              phoneVerified: true,
              onboardingCompleted: true,
              isFullyVerified: false,
              email: 'test@example.com',
              phone: '+1234567890',
            ),
          ),
        );

        bool successCalled = false;
        String? unverifiedMethod;
        String? additionalEmail;
        String? additionalPhone;

        await viewModel.verify(
          identifier: 'test@example.com',
          code: '123456',
          onSuccess: () => successCalled = true,
          onAdditionalVerificationNeeded: (method, email, phone) {
            unverifiedMethod = method;
            additionalEmail = email;
            additionalPhone = phone;
          },
          onOnboardingIncomplete: () {},
        );

        expect(successCalled, isFalse);
        expect(unverifiedMethod, 'email');
        expect(additionalEmail, 'test@example.com');
        expect(additionalPhone, '+1234567890');
      },
    );

    test('verify sets error message on invalid code', () async {
      when(
        () => mockVerifyOtpUseCase(any(), any()),
      ).thenAnswer((_) async => const Success(false));

      await viewModel.verify(
        identifier: 'test@example.com',
        code: '123456',
        onSuccess: () {},
        onAdditionalVerificationNeeded: (method, email, phone) {},
        onOnboardingIncomplete: () {},
      );

      expect(viewModel.errorMessage, 'authInvalidVerificationCode');
      expect(viewModel.isLoading, isFalse);
    });

    test('verify propagates failure message', () async {
      when(() => mockVerifyOtpUseCase(any(), any())).thenAnswer(
        (_) async => FailureResult(
          AuthFailure(AppErrorCode.invalidCredentials, 'Server error'),
        ),
      );

      await viewModel.verify(
        identifier: 'test@example.com',
        code: '123456',
        onSuccess: () {},
        onAdditionalVerificationNeeded: (method, email, phone) {},
        onOnboardingIncomplete: () {},
      );

      expect(viewModel.errorMessage, 'Server error');
    });

    test('resend calls SendOtpUseCase', () async {
      when(
        () => mockSendOtpUseCase(any()),
      ).thenAnswer((_) async => const Success(null));

      await viewModel.resend('test@example.com');

      verify(() => mockSendOtpUseCase('test@example.com')).called(1);
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.errorMessage, isNull);
    });

    test('resend handles failure', () async {
      when(() => mockSendOtpUseCase(any())).thenAnswer(
        (_) async => FailureResult(
          AuthFailure(AppErrorCode.invalidCredentials, 'Rate limit exceeded'),
        ),
      );

      await viewModel.resend('test@example.com');

      expect(viewModel.errorMessage, 'Rate limit exceeded');
    });
    test('requestFamilyOtp sends OTP via family endpoint if method is verified', () async {
      when(() => mockGetVerificationStatusUseCase()).thenAnswer(
        (_) async => const Success(
          VerificationStatus(
            emailVerified: true,
            phoneVerified: true,
            onboardingCompleted: true,
            isFullyVerified: true,
            email: 'test@example.com',
            phone: '+1234567890',
          ),
        ),
      );
      when(
        () => mockRequestFamilyAccountOtpUseCase(method: any(named: 'method')),
      ).thenAnswer((_) async => const Success('OTP sent'));

      bool successCalled = false;
      await viewModel.requestFamilyOtp(
        isEmail: true,
        onSuccess: () => successCalled = true,
        onError: (_) {},
      );

      verify(
        () => mockRequestFamilyAccountOtpUseCase(method: any(named: 'method')),
      ).called(1);
      expect(successCalled, isTrue);
    });

    test(
      'requestFamilyOtp reports error if email is not yet verified',
      () async {
        when(() => mockGetVerificationStatusUseCase()).thenAnswer(
          (_) async => const Success(
            VerificationStatus(
              emailVerified: false,
              phoneVerified: true,
              onboardingCompleted: true,
              isFullyVerified: false,
              email: 'test@example.com',
              phone: '+1234567890',
            ),
          ),
        );

        String? error;
        await viewModel.requestFamilyOtp(
          isEmail: true,
          onSuccess: () {},
          onError: (err) => error = err,
        );

        expect(error, 'Your email address is not verified yet.');
        verifyNever(() => mockSendOtpUseCase(any()));
        verifyNever(
          () => mockRequestFamilyAccountOtpUseCase(method: any(named: 'method')),
        );
      },
    );
  });
}
