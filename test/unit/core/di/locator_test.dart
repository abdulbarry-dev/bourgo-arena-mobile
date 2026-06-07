import 'package:bourgo_arena_mobile/domain/usecases/auth/login_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/logout_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/register_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:checks/checks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
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

  group('Locator', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      if (locator.isRegistered<SessionRepository>()) {
        await locator.reset();
      }
    });

    tearDown(() async {
      await locator.reset();
    });

    test('initLocator registers all dependencies correctly', () async {
      await initLocator();

      // Check key components
      check(locator.isRegistered<SessionRepository>()).isTrue();
      check(locator.isRegistered<ApiClient>()).isTrue();
      check(locator.isRegistered<AuthRepository>()).isTrue();
      check(locator.isRegistered<AuthStateNotifier>()).isTrue();

      // Verify singleton behavior
      final instance1 = locator<AuthRepository>();
      final instance2 = locator<AuthRepository>();
      check(instance1).identicalTo(instance2);
    });

    test('All use cases are registered', () async {
      await initLocator();

      // Checking a subset of use cases to verify the registrations in locator.dart
      check(locator.isRegistered<LoginUseCase>()).isTrue();
      check(locator.isRegistered<LogoutUseCase>()).isTrue();
      check(locator.isRegistered<RegisterUseCase>()).isTrue();
      check(locator.isRegistered<GetActivitiesUseCase>()).isTrue();
    });
  });
}
