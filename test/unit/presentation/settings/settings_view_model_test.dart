import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/complete_language_selection_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/get_locale_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/get_notifications_enabled_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/get_theme_mode_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/is_language_selected_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/set_locale_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/set_notifications_enabled_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/set_theme_mode_use_case.dart';
import 'package:bourgo_arena_mobile/core/utils/device_token_registrar.dart';
import 'package:bourgo_arena_mobile/presentation/settings/viewmodels/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';
import 'package:package_info_plus/package_info_plus.dart';

class _MockGetThemeMode extends Mock implements GetThemeModeUseCase {}

class _MockSetThemeMode extends Mock implements SetThemeModeUseCase {}

class _MockGetLocale extends Mock implements GetLocaleUseCase {}

class _MockSetLocale extends Mock implements SetLocaleUseCase {}

class _MockIsLanguageSelected extends Mock
    implements IsLanguageSelectedUseCase {}

class _MockCompleteLanguageSelection extends Mock
    implements CompleteLanguageSelectionUseCase {}

class _MockGetNotificationsEnabled extends Mock
    implements GetNotificationsEnabledUseCase {}

class _MockSetNotificationsEnabled extends Mock
    implements SetNotificationsEnabledUseCase {}

class _MockDeviceTokenRegistrar extends Mock implements DeviceTokenRegistrar {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(ThemeMode.system);
    registerFallbackValue(const Locale('en'));

    const MethodChannel('dev.fluttercommunity.plus/package_info')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, dynamic>{
          'appName': 'Bourgo Arena',
          'packageName': 'com.example.bourgo',
          'version': '1.0.0',
          'buildNumber': '1',
          'buildSignature': '',
        };
      }
      return null;
    });
  });

  late SettingsViewModel viewModel;
  late _MockGetThemeMode mockGetTheme;
  late _MockSetThemeMode mockSetTheme;
  late _MockGetLocale mockGetLocale;
  late _MockSetLocale mockSetLocale;
  late _MockIsLanguageSelected mockIsLangSelected;
  late _MockCompleteLanguageSelection mockCompleteLangSelection;
  late _MockGetNotificationsEnabled mockGetNotif;
  late _MockSetNotificationsEnabled mockSetNotif;
  late _MockDeviceTokenRegistrar mockDeviceTokenRegistrar;

  setUp(() {
    mockGetTheme = _MockGetThemeMode();
    mockSetTheme = _MockSetThemeMode();
    mockGetLocale = _MockGetLocale();
    mockSetLocale = _MockSetLocale();
    mockIsLangSelected = _MockIsLanguageSelected();
    mockCompleteLangSelection = _MockCompleteLanguageSelection();
    mockGetNotif = _MockGetNotificationsEnabled();
    mockSetNotif = _MockSetNotificationsEnabled();
    mockDeviceTokenRegistrar = _MockDeviceTokenRegistrar();

    when(
      () => mockGetTheme(),
    ).thenAnswer((_) async => Result.success(ThemeMode.system));
    when(
      () => mockGetLocale(),
    ).thenAnswer((_) async => Result.success(const Locale('en')));
    when(() => mockGetNotif()).thenAnswer((_) async => Result.success(true));
    when(
      () => mockIsLangSelected(),
    ).thenAnswer((_) async => Result.success(true));
    when(
      () => mockCompleteLangSelection(),
    ).thenAnswer((_) async => Result.success(null));

    when(
      () => mockSetTheme(any()),
    ).thenAnswer((_) async => Result.success(null));
    when(
      () => mockSetLocale(any()),
    ).thenAnswer((_) async => Result.success(null));
    when(
      () => mockSetNotif(any()),
    ).thenAnswer((_) async => Result.success(null));
    when(
      () => mockDeviceTokenRegistrar.registerIfPossible(
        requireNotificationsEnabled: any(named: 'requireNotificationsEnabled'),
      ),
    ).thenAnswer((_) async {});

    viewModel = SettingsViewModel(
      mockGetTheme,
      mockSetTheme,
      mockGetLocale,
      mockSetLocale,
      mockIsLangSelected,
      mockCompleteLangSelection,
      mockGetNotif,
      mockSetNotif,
      mockDeviceTokenRegistrar,
    );
  });

  group('SettingsViewModel', () {
    test('initialize loads state from use cases and notifies once', () async {
      var notifyCount = 0;
      viewModel.addListener(() => notifyCount += 1);

      await viewModel.initialize();

      expect(viewModel.themeMode, ThemeMode.system);
      expect(viewModel.locale, const Locale('en'));
      expect(viewModel.notificationsEnabled, isTrue);
      expect(viewModel.isLanguageSelected, isTrue);
      expect(notifyCount, 1);

      verify(() => mockGetTheme()).called(1);
      verify(() => mockGetLocale()).called(1);
      verify(() => mockGetNotif()).called(1);
      verify(() => mockIsLangSelected()).called(1);
    });

    test('initialize handles failures and keeps defaults', () async {
      when(() => mockGetTheme()).thenAnswer(
        (_) async =>
            Result.failure(ServerFailure(AppErrorCode.serverError, 'boom')),
      );
      when(() => mockGetLocale()).thenAnswer(
        (_) async =>
            Result.failure(ServerFailure(AppErrorCode.serverError, 'boom')),
      );
      when(() => mockGetNotif()).thenAnswer(
        (_) async =>
            Result.failure(ServerFailure(AppErrorCode.serverError, 'boom')),
      );
      when(() => mockIsLangSelected()).thenAnswer(
        (_) async =>
            Result.failure(ServerFailure(AppErrorCode.serverError, 'boom')),
      );

      var notifyCount = 0;
      viewModel.addListener(() => notifyCount += 1);

      await viewModel.initialize();

      // Defaults defined in the ViewModel implementation
      expect(viewModel.themeMode, ThemeMode.system);
      expect(viewModel.locale.languageCode, 'en');
      expect(viewModel.notificationsEnabled, isTrue);
      expect(viewModel.isLanguageSelected, isFalse);
      expect(notifyCount, 1);
    });

    test('updateThemeMode updates and calls use case; notifies', () async {
      var notifyCount = 0;
      viewModel.addListener(() => notifyCount += 1);

      await viewModel.updateThemeMode(ThemeMode.dark);

      expect(viewModel.themeMode, ThemeMode.dark);
      expect(notifyCount, 1);
      verify(() => mockSetTheme(ThemeMode.dark)).called(1);
    });

    test(
      'updateLocale persists and notifies but does NOT mark as selected',
      () async {
        // Start with language NOT selected
        when(
          () => mockIsLangSelected(),
        ).thenAnswer((_) async => Result.success(false));
        await viewModel.initialize();
        expect(viewModel.isLanguageSelected, isFalse);

        when(
          () => mockSetLocale(const Locale('fr')),
        ).thenAnswer((_) async => Result.success(null));

        var notifyCount = 0;
        viewModel.addListener(() => notifyCount += 1);

        await viewModel.updateLocale(const Locale('fr'));

        expect(viewModel.locale, const Locale('fr'));
        expect(viewModel.isLanguageSelected, isFalse);
        expect(notifyCount, 1);
        verify(() => mockSetLocale(const Locale('fr'))).called(1);
      },
    );

    test('confirmLanguageSelection marks as selected and notifies', () async {
      // Set initial state to false
      when(
        () => mockIsLangSelected(),
      ).thenAnswer((_) async => Result.success(false));
      await viewModel.initialize();
      expect(viewModel.isLanguageSelected, isFalse);

      var notifyCount = 0;
      viewModel.addListener(() => notifyCount += 1);

      await viewModel.confirmLanguageSelection();

      expect(viewModel.isLanguageSelected, isTrue);
      expect(notifyCount, 1);
      verify(() => mockCompleteLangSelection()).called(1);
    });

    test('toggleNotifications updates and calls use case', () async {
      var notifyCount = 0;
      viewModel.addListener(() => notifyCount += 1);

      await viewModel.toggleNotifications(false);

      expect(viewModel.notificationsEnabled, isFalse);
      expect(notifyCount, 1);
      verify(() => mockSetNotif(false)).called(1);
      verifyNever(
        () => mockDeviceTokenRegistrar.registerIfPossible(
          requireNotificationsEnabled: any(
            named: 'requireNotificationsEnabled',
          ),
        ),
      );
    });

    test('toggleNotifications registers token when enabling', () async {
      var notifyCount = 0;
      viewModel.addListener(() => notifyCount += 1);

      await viewModel.toggleNotifications(false);
      await viewModel.toggleNotifications(true);

      expect(viewModel.notificationsEnabled, isTrue);
      verify(() => mockSetNotif(false)).called(1);
      verify(() => mockSetNotif(true)).called(1);
      verify(
        () => mockDeviceTokenRegistrar.registerIfPossible(
          requireNotificationsEnabled: false,
        ),
      ).called(1);
      expect(notifyCount, 2);
    });
  });
}
