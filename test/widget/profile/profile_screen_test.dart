import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/logout_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../unit/data/repositories/repository_test_fixtures.dart';

class MockGetProfile extends Mock implements GetUserProfileUseCase {}

class MockLogout extends Mock implements LogoutUseCase {}

void main() {
  late MockGetProfile mockGetProfile;
  late MockLogout mockLogout;

  setUp(() async {
    mockGetProfile = MockGetProfile();
    mockLogout = MockLogout();

    await locator.reset();
    locator.registerLazySingleton<GetUserProfileUseCase>(() => mockGetProfile);
    locator.registerLazySingleton<LogoutUseCase>(() => mockLogout);
  });

  setUpAll(() {
    HttpOverrides.global = _FakeHttpOverrides();
  });

  tearDownAll(() {
    HttpOverrides.global = null;
  });

  testWidgets('initial render shows user name when profile loads', (
    tester,
  ) async {
    final user = testUserEntity(firstName: 'Jamie', lastName: 'Rivera');
    when(() => mockGetProfile()).thenAnswer((_) async => Success(user));

    await tester.pumpWidget(_buildApp(const ProfileScreen()));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.textContaining('JAMIE'), findsOneWidget);
  });

  testWidgets('loading state shows CircularProgressIndicator', (tester) async {
    final completer = Completer<Result<User, Failure>>();
    when(() => mockGetProfile()).thenAnswer((_) => completer.future);

    await tester.pumpWidget(_buildApp(const ProfileScreen()));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(Success(testUserEntity()));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('error state displays loading error message', (tester) async {
    when(
      () => mockGetProfile(),
    ).thenAnswer((_) async => FailureResult(ServerFailure('boom')));

    await tester.pumpWidget(_buildApp(const ProfileScreen()));
    await tester.pump(const Duration(milliseconds: 500));

    final l10n = AppLocalizations.of(
      tester.element(find.byType(ProfileScreen)),
    )!;
    expect(find.text(l10n.commonLoadingError), findsOneWidget);
  });

  testWidgets('logout button is present and tappable', (tester) async {
    when(
      () => mockGetProfile(),
    ).thenAnswer((_) async => Success(testUserEntity()));

    await tester.pumpWidget(_buildApp(const ProfileScreen()));
    await tester.pump(const Duration(milliseconds: 500));

    final l10n = AppLocalizations.of(
      tester.element(find.byType(ProfileScreen)),
    )!;
    final logoutButton = find.widgetWithText(TextButton, l10n.profileLogout);
    expect(logoutButton, findsOneWidget);

    await tester.tap(logoutButton);
    await tester.pump();

    expect(find.byType(ProfileScreen), findsOneWidget);
  });
}

Widget _buildApp(Widget home) {
  return MaterialApp(
    locale: AppLocalizations.supportedLocales.first,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: home,
  );
}

class _FakeHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _FakeHttpClient();
}

class _FakeHttpClient extends Fake implements HttpClient {
  @override
  bool autoUncompress = true;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _FakeHttpRequest();

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async =>
      _FakeHttpRequest();
}

class _FakeHttpRequest extends Fake implements HttpClientRequest {
  @override
  Encoding get encoding => utf8;

  @override
  set encoding(Encoding value) {}

  @override
  Future<HttpClientResponse> close() async {
    return _FakeHttpResponse.fromBytes(_transparentPngBytes);
  }
}

class _FakeHttpHeaders extends Fake implements HttpHeaders {}

class _FakeHttpResponse extends Fake implements HttpClientResponse {
  _FakeHttpResponse.fromBytes(this._bytes);

  final List<int> _bytes;

  @override
  int get statusCode => 200;

  @override
  int get contentLength => _bytes.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  HttpHeaders get headers => _FakeHttpHeaders();

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int>)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([_bytes]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError ?? false,
    );
  }
}

const List<int> _transparentPngBytes = <int>[
  137,
  80,
  78,
  71,
  13,
  10,
  26,
  10,
  0,
  0,
  0,
  13,
  73,
  72,
  68,
  82,
  0,
  0,
  0,
  1,
  0,
  0,
  0,
  1,
  8,
  6,
  0,
  0,
  0,
  31,
  21,
  196,
  137,
  0,
  0,
  0,
  12,
  73,
  68,
  65,
  84,
  8,
  153,
  99,
  0,
  1,
  0,
  0,
  5,
  0,
  1,
  13,
  10,
  44,
  90,
  0,
  0,
  0,
  0,
  73,
  69,
  78,
  68,
  174,
  66,
  96,
  130,
];
