import 'package:flutter/material.dart';
import 'package:flutter_clean_bloc/app.dart';
import 'package:flutter_clean_bloc/domain/use_cases/notes_use_cases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:nuvigator/next.dart';
import 'package:provider/provider.dart';

Future<void> launchApp(WidgetTester tester, http.Client httpClient) async {
  await tester.pumpWidget(App(httpClient: httpClient));
  await tester.pump();
}

Future<void> launchRoutes(
  WidgetTester tester,
  List<NuRoute> routes,
  String initialRoute,
  NotesUseCases useCases,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Provider<NotesUseCases>(
        create: (_) => useCases,
        child: Nuvigator.routes(routes: routes, initialRoute: initialRoute),
      ),
    ),
  );
  await tester.pump();
}

Future<void> launchRoute(
  WidgetTester tester,
  NuRoute route,
  NotesUseCases useCases,
) =>
    launchRoutes(tester, [route], route.path, useCases);

Future<void> expectExceptionThrown<T extends Exception>(
  Future Function() futureBlock,
) async {
  try {
    await futureBlock();
    fail('Exception not thrown');
  } catch (e) {
    expect(e, isInstanceOf<T>());
  }
}
