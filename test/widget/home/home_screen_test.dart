import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/service/get_services_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/common/empty_state.dart';
import 'package:bourgo_arena_mobile/presentation/home/home_screen.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/bourgo_image_card.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../unit/data/repositories/repository_test_fixtures.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';

class MockGetActivities extends Mock implements GetActivitiesUseCase {}

class MockGetCourses extends Mock implements GetCoursesUseCase {}

class MockGetServices extends Mock implements GetServicesUseCase {}

void main() {
  late MockGetActivities mockActivities;
  late MockGetCourses mockCourses;
  late MockGetServices mockServices;

  setUp(() async {
    mockActivities = MockGetActivities();
    mockCourses = MockGetCourses();
    mockServices = MockGetServices();

    await locator.reset();
    locator.registerLazySingleton<GetActivitiesUseCase>(() => mockActivities);
    locator.registerLazySingleton<GetCoursesUseCase>(() => mockCourses);
    locator.registerLazySingleton<GetServicesUseCase>(() => mockServices);
  });

  setUpAll(() {
    HttpOverrides.global = _FakeHttpOverrides();
  });

  tearDownAll(() {
    HttpOverrides.global = null;
  });

  testWidgets('initial render shows key UI elements', (tester) async {
    when(
      () => mockActivities(),
    ).thenAnswer((_) async => Success([testActivityEntity()]));
    when(
      () => mockCourses(),
    ).thenAnswer((_) async => Success([testCourseEntity()]));
    when(() => mockServices()).thenAnswer((_) async => Success([testServiceEntity()]));

    await tester.pumpWidget(_buildApp(const HomeScreen()));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(IconButton), findsNWidgets(2));
    expect(find.byType(BourgoImageCard), findsWidgets);
  });

  testWidgets('loading state shows CircularProgressIndicator', (tester) async {
    final activitiesCompleter = Completer<Result<List<Activity>, Failure>>();
    when(() => mockActivities()).thenAnswer((_) => activitiesCompleter.future);
    when(() => mockCourses()).thenAnswer(
      (_) async =>
          Success([testCourseEntity(dayOfWeek: DateTime.now().weekday)]),
    );
    when(() => mockServices()).thenAnswer((_) async => const Success([]));

    await tester.pumpWidget(_buildApp(const HomeScreen()));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    activitiesCompleter.complete(Success([testActivityEntity()]));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('when use cases return failure, empty lists are shown', (
    tester,
  ) async {
    when(() => mockActivities()).thenAnswer(
      (_) async => FailureResult(
        NetworkFailure(AppErrorCode.networkUnavailable, 'offline'),
      ),
    );
    when(() => mockCourses()).thenAnswer(
      (_) async =>
          FailureResult(ServerFailure(AppErrorCode.serverError, 'error')),
    );
    when(() => mockServices()).thenAnswer(
      (_) async =>
          FailureResult(ServerFailure(AppErrorCode.serverError, 'error')),
    );

    await tester.pumpWidget(_buildApp(const HomeScreen()));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(EmptyState), findsNWidgets(2));
  });
}

Widget _buildApp(Widget home) {
  return MaterialApp(
    locale: AppLocalizations.supportedLocales.first,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: BourgoTheme.darkTheme,
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
