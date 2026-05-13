import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/send_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/verify_otp_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/auth/otp/otp_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockVerifyOtpUseCase extends Mock implements VerifyOtpUseCase {}

class MockSendOtpUseCase extends Mock implements SendOtpUseCase {}

void main() {
  late MockVerifyOtpUseCase mockVerifyOtpUseCase;
  late MockSendOtpUseCase mockSendOtpUseCase;
  late OtpViewModel viewModel;

  setUp(() {
    mockVerifyOtpUseCase = MockVerifyOtpUseCase();
    mockSendOtpUseCase = MockSendOtpUseCase();
    viewModel = OtpViewModel(mockVerifyOtpUseCase, mockSendOtpUseCase);
  });

  group('OtpViewModel -', () {
    test('verify calls VerifyOtpUseCase and triggers onSuccess', () async {
      when(
        () => mockVerifyOtpUseCase(any(), any()),
      ).thenAnswer((_) async => const Success(true));

      bool successCalled = false;
      await viewModel.verify(
        identifier: 'test@example.com',
        code: '123456',
        onSuccess: () => successCalled = true,
      );

      verify(
        () => mockVerifyOtpUseCase('test@example.com', '123456'),
      ).called(1);
      expect(successCalled, isTrue);
      expect(viewModel.isLoading, isFalse);
    });

    test('verify sets error message on invalid code', () async {
      when(
        () => mockVerifyOtpUseCase(any(), any()),
      ).thenAnswer((_) async => const Success(false));

      await viewModel.verify(
        identifier: 'test@example.com',
        code: '123456',
        onSuccess: () {},
      );

      expect(viewModel.errorMessage, 'Invalid verification code');
      expect(viewModel.isLoading, isFalse);
    });

    test('verify propagates failure message', () async {
      when(
        () => mockVerifyOtpUseCase(any(), any()),
      ).thenAnswer((_) async => FailureResult(AuthFailure('Server error')));

      await viewModel.verify(
        identifier: 'test@example.com',
        code: '123456',
        onSuccess: () {},
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
        (_) async => FailureResult(AuthFailure('Rate limit exceeded')),
      );

      await viewModel.resend('test@example.com');

      expect(viewModel.errorMessage, 'Rate limit exceeded');
    });
  });
}
