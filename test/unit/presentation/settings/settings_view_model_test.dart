import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/delete_account_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/complete_language_selection_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/get_locale_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/get_notifications_enabled_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/get_theme_mode_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/is_language_selected_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/set_locale_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/set_notifications_enabled_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/set_theme_mode_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/is_theme_selected_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/settings/complete_theme_selection_use_case.dart';
import 'package:bourgo_arena_mobile/core/utils/device_token_registrar.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/user_repository.dart';
import 'package:bourgo_arena_mobile/presentation/settings/viewmodels/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';

class _MockGetThemeMode extends Mock implements GetThemeModeUseCase {}

class _MockSetThemeMode extends Mock implements SetThemeModeUseCase {}

class _MockGetLocale extends Mock implements GetLocaleUseCase {}

class _MockSetLocale extends Mock implements SetLocaleUseCase {}

class _MockIsLanguageSelected extends Mock
    implements IsLanguageSelectedUseCase {}

class _MockCompleteLanguageSelection extends Mock
    implements CompleteLanguageSelectionUseCase {}

class _MockIsThemeSelected extends Mock implements IsThemeSelectedUseCase {}

class _MockCompleteThemeSelection extends Mock
    implements CompleteThemeSelectionUseCase {}

class _MockGetNotificationsEnabled extends Mock
    implements GetNotificationsEnabledUseCase {}

class _MockSetNotificationsEnabled extends Mock
    implements SetNotificationsEnabledUseCase {}

class _MockDeleteAccount extends Mock implements DeleteAccountUseCase {}

class _MockDeviceTokenRegistrar extends Mock implements DeviceTokenRegistrar {}

class _MockSessionRepository extends Mock implements SessionRepository {}

class _MockUserRepository extends Mock implements UserRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(ThemeMode.system);
    registerFallbackValue(const Locale('en'));

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('dev.fluttercommunity.plus/package_info'),
          (MethodCall methodCall) async {
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
          },
        );
  });

  late SettingsViewModel viewModel;
  late _MockGetThemeMode mockGetTheme;
  late _MockSetThemeMode mockSetTheme;
  late _MockGetLocale mockGetLocale;
  late _MockSetLocale mockSetLocale;
  late _MockIsLanguageSelected mockIsLangSelected;
  late _MockCompleteLanguageSelection mockCompleteLangSelection;
  late _MockIsThemeSelected mockIsThemeSelected;
  late _MockCompleteThemeSelection mockCompleteThemeSelection;
  late _MockGetNotificationsEnabled mockGetNotif;
  late _MockSetNotificationsEnabled mockSetNotif;
  late _MockDeviceTokenRegistrar mockDeviceTokenRegistrar;
  late _MockDeleteAccount mockDeleteAccount;
  late _MockSessionRepository mockSessionRepository;
  late _MockUserRepository mockUserRepository;

  setUp(() {
    mockGetTheme = _MockGetThemeMode();
    mockSetTheme = _MockSetThemeMode();
    mockGetLocale = _MockGetLocale();
    mockSetLocale = _MockSetLocale();
    mockIsLangSelected = _MockIsLanguageSelected();
    mockCompleteLangSelection = _MockCompleteLanguageSelection();
    mockIsThemeSelected = _MockIsThemeSelected();
    mockCompleteThemeSelection = _MockCompleteThemeSelection();
    mockGetNotif = _MockGetNotificationsEnabled();
    mockSetNotif = _MockSetNotificationsEnabled();
    mockDeviceTokenRegistrar = _MockDeviceTokenRegistrar();
    mockDeleteAccount = _MockDeleteAccount();
    mockSessionRepository = _MockSessionRepository();
    mockUserRepository = _MockUserRepository();

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
      () => mockIsThemeSelected(),
    ).thenAnswer((_) async => Result.success(true));
    when(
      () => mockCompleteThemeSelection(),
    ).thenAnswer((_) async => Result.success(null));
    when(
      () => mockSessionRepository.arePromotionalNotificationsEnabled(),
    ).thenAnswer((_) async => Result.success(true));
    when(
      () => mockSessionRepository.areAccountNotificationsEnabled(),
    ).thenAnswer((_) async => Result.success(true));

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
    when(
      () => mockUserRepository.updatePreferences(any()),
    ).thenAnswer((_) async => Result.success(null));

    viewModel = SettingsViewModel(
      mockGetTheme,
      mockSetTheme,
      mockGetLocale,
      mockSetLocale,
      mockIsLangSelected,
      mockCompleteLangSelection,
      mockIsThemeSelected,
      mockCompleteThemeSelection,
      mockGetNotif,
      mockSetNotif,
      mockDeviceTokenRegistrar,
      mockDeleteAccount,
      mockSessionRepository,
      mockUserRepository,
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
      expect(viewModel.isThemeSelected, isTrue);
      expect(notifyCount, 1);

      verify(() => mockGetTheme()).called(1);
      verify(() => mockGetLocale()).called(1);
      verify(() => mockGetNotif()).called(1);
      verify(() => mockIsLangSelected()).called(1);
      verify(() => mockIsThemeSelected()).called(1);
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
      when(() => mockIsThemeSelected()).thenAnswer(
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
      expect(viewModel.isThemeSelected, isFalse);
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

    test('confirmThemeSelection marks as selected and notifies', () async {
      // Set initial state to false
      when(
        () => mockIsThemeSelected(),
      ).thenAnswer((_) async => Result.success(false));
      await viewModel.initialize();
      expect(viewModel.isThemeSelected, isFalse);

      var notifyCount = 0;
      viewModel.addListener(() => notifyCount += 1);

      await viewModel.confirmThemeSelection();

      expect(viewModel.isThemeSelected, isTrue);
      expect(notifyCount, 1);
      verify(() => mockCompleteThemeSelection()).called(1);
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
