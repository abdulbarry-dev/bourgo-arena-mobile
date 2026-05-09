import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/get_locale_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/get_notifications_enabled_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/get_theme_mode_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/is_language_selected_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/set_locale_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/set_notifications_enabled_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/set_theme_mode_use_case.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/presentation/settings/viewmodels/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetThemeModeUseCase extends Mock implements GetThemeModeUseCase {}

class MockSetThemeModeUseCase extends Mock implements SetThemeModeUseCase {}

class MockGetLocaleUseCase extends Mock implements GetLocaleUseCase {}

class MockSetLocaleUseCase extends Mock implements SetLocaleUseCase {}

class MockIsLanguageSelectedUseCase extends Mock
    implements IsLanguageSelectedUseCase {}

class MockGetNotificationsEnabledUseCase extends Mock
    implements GetNotificationsEnabledUseCase {}

class MockSetNotificationsEnabledUseCase extends Mock
    implements SetNotificationsEnabledUseCase {}

void main() {
  late SettingsViewModel viewModel;
  late MockGetThemeModeUseCase mockGetThemeModeUseCase;
  late MockSetThemeModeUseCase mockSetThemeModeUseCase;
  late MockGetLocaleUseCase mockGetLocaleUseCase;
  late MockSetLocaleUseCase mockSetLocaleUseCase;
  late MockIsLanguageSelectedUseCase mockIsLanguageSelectedUseCase;
  late MockGetNotificationsEnabledUseCase mockGetNotificationsEnabledUseCase;
  late MockSetNotificationsEnabledUseCase mockSetNotificationsEnabledUseCase;

  setUp(() {
    mockGetThemeModeUseCase = MockGetThemeModeUseCase();
    mockSetThemeModeUseCase = MockSetThemeModeUseCase();
    mockGetLocaleUseCase = MockGetLocaleUseCase();
    mockSetLocaleUseCase = MockSetLocaleUseCase();
    mockIsLanguageSelectedUseCase = MockIsLanguageSelectedUseCase();
    mockGetNotificationsEnabledUseCase = MockGetNotificationsEnabledUseCase();
    mockSetNotificationsEnabledUseCase = MockSetNotificationsEnabledUseCase();

    viewModel = SettingsViewModel(
      mockGetThemeModeUseCase,
      mockSetThemeModeUseCase,
      mockGetLocaleUseCase,
      mockSetLocaleUseCase,
      mockIsLanguageSelectedUseCase,
      mockGetNotificationsEnabledUseCase,
      mockSetNotificationsEnabledUseCase,
    );

    registerFallbackValue(ThemeMode.system);
    registerFallbackValue(const Locale('en'));

    // Default mock behavior for initialize()
    when(
      () => mockGetThemeModeUseCase(),
    ).thenAnswer((_) async => const Success(ThemeMode.system));
    when(
      () => mockGetLocaleUseCase(),
    ).thenAnswer((_) async => const Success(Locale('en')));
    when(
      () => mockGetNotificationsEnabledUseCase(),
    ).thenAnswer((_) async => const Success(true));
    when(
      () => mockIsLanguageSelectedUseCase(),
    ).thenAnswer((_) async => const Success(false));
  });

  group('SettingsViewModel', () {
    test('initial state has default values', () {
      expect(viewModel.themeMode, ThemeMode.system);
      expect(viewModel.locale, const Locale('en'));
      expect(viewModel.notificationsEnabled, true);
      expect(viewModel.isLanguageSelected, false);
    });

    test('initialize loads persisted values when all succeed', () async {
      // Arrange
      when(
        () => mockGetThemeModeUseCase(),
      ).thenAnswer((_) async => const Success(ThemeMode.dark));
      when(
        () => mockGetLocaleUseCase(),
      ).thenAnswer((_) async => const Success(Locale('fr')));
      when(
        () => mockGetNotificationsEnabledUseCase(),
      ).thenAnswer((_) async => const Success(false));
      when(
        () => mockIsLanguageSelectedUseCase(),
      ).thenAnswer((_) async => const Success(true));

      // Act
      await viewModel.initialize();

      // Assert
      expect(viewModel.themeMode, ThemeMode.dark);
      expect(viewModel.locale, const Locale('fr'));
      expect(viewModel.notificationsEnabled, false);
      expect(viewModel.isLanguageSelected, true);
      verify(() => mockGetThemeModeUseCase()).called(1);
      verify(() => mockGetLocaleUseCase()).called(1);
      verify(() => mockGetNotificationsEnabledUseCase()).called(1);
      verify(() => mockIsLanguageSelectedUseCase()).called(1);
    });

    test('initialize keeps defaults when use cases fail', () async {
      // Arrange
      when(
        () => mockGetThemeModeUseCase(),
      ).thenAnswer((_) async => const FailureResult(ServerFailure('error')));
      when(
        () => mockGetLocaleUseCase(),
      ).thenAnswer((_) async => const FailureResult(ServerFailure('error')));
      when(
        () => mockGetNotificationsEnabledUseCase(),
      ).thenAnswer((_) async => const FailureResult(ServerFailure('error')));
      when(
        () => mockIsLanguageSelectedUseCase(),
      ).thenAnswer((_) async => const FailureResult(ServerFailure('error')));

      // Act
      await viewModel.initialize();

      // Assert
      expect(viewModel.themeMode, ThemeMode.system);
      expect(viewModel.locale, const Locale('en'));
      expect(viewModel.notificationsEnabled, true);
      expect(viewModel.isLanguageSelected, false);
    });

    test('updateThemeMode updates state and persists', () async {
      // Arrange
      when(
        () => mockSetThemeModeUseCase(any()),
      ).thenAnswer((_) async => const Success(null));

      // Act
      await viewModel.updateThemeMode(ThemeMode.light);

      // Assert
      expect(viewModel.themeMode, ThemeMode.light);
      verify(() => mockSetThemeModeUseCase(ThemeMode.light)).called(1);
    });

    test('updateThemeMode does nothing if mode is same', () async {
      // Act
      await viewModel.updateThemeMode(ThemeMode.system);

      // Assert
      verifyNever(() => mockSetThemeModeUseCase(any()));
    });

    test(
      'updateLocale updates state, persists, and sets languageSelected',
      () async {
        // Arrange
        when(
          () => mockSetLocaleUseCase(any()),
        ).thenAnswer((_) async => const Success(null));

        // Act
        await viewModel.updateLocale(const Locale('it'));

        // Assert
        expect(viewModel.locale, const Locale('it'));
        expect(viewModel.isLanguageSelected, true);
        verify(() => mockSetLocaleUseCase(const Locale('it'))).called(1);
      },
    );

    test(
      'updateLocale does nothing if locale is same and already selected',
      () async {
        // Arrange
        when(
          () => mockIsLanguageSelectedUseCase(),
        ).thenAnswer((_) async => const Success(true));
        when(
          () => mockGetLocaleUseCase(),
        ).thenAnswer((_) async => const Success(Locale('en')));
        await viewModel.initialize();

        // Act
        await viewModel.updateLocale(const Locale('en'));

        // Assert
        verifyNever(() => mockSetLocaleUseCase(any()));
      },
    );

    test('toggleNotifications updates state and persists', () async {
      // Arrange
      when(
        () => mockSetNotificationsEnabledUseCase(any()),
      ).thenAnswer((_) async => const Success(null));

      // Act
      await viewModel.toggleNotifications(false);

      // Assert
      expect(viewModel.notificationsEnabled, false);
      verify(() => mockSetNotificationsEnabledUseCase(false)).called(1);
    });
  });
}
