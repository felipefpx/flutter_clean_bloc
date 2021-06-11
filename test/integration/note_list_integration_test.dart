import 'dart:convert';

import 'package:flutter_clean_bloc/data/data_sources/remote/notes_api.dart';
import 'package:flutter_clean_bloc/data/models/external_note.dart';
import 'package:flutter_clean_bloc/domain/models/note.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../fakes.dart';
import '../helpers.dart';
import '../presentation/mocks.dart';
import '../presentation/note_list/note_list_screen_robot.dart';

void main() {
  late http.Client httpClient;
  final externalNotes = fakeExternalNotes;
  List<Note> getNotes() =>
      externalNotes.map((extNote) => extNote.toNote()).toList();

  group('When the app', () {
    setUp(() {
      httpClient = MockHttpClient();
    });

    tearDown(() {
      reset(httpClient);
    });

    testWidgets(
      'loads the notes, assert notes displayed',
      (tester) async {
        when(
          () => httpClient.get(
            Uri.parse('${NotesApi.apiBaseUrl}/notes'),
            headers: NotesApi.defaultHeaders,
          ),
        ).thenAnswer((_) async => fakeResponse(jsonEncode(externalNotes), 200));

        await launchApp(tester, httpClient);

        NoteListScreenRobot.expectScreenVisible(
          loading: true,
          shimmering: true,
        );

        await tester.pump();

        NoteListScreenRobot.expectScreenVisible(
          loading: true,
          shimmering: false,
          notes: getNotes(),
        );

        await tester.pump();

        NoteListScreenRobot.expectScreenVisible(
          loading: true,
          notes: getNotes(),
        );
      },
    );

    testWidgets(
      'loads the notes with error, assert error displayed',
      (tester) async {
        when(
          () => httpClient.get(
            Uri.parse('${NotesApi.apiBaseUrl}/notes'),
            headers: NotesApi.defaultHeaders,
          ),
        ).thenAnswer((_) async => fakeResponse('{}', 400));

        await launchApp(tester, httpClient);

        NoteListScreenRobot.expectScreenVisible(
          loading: true,
          shimmering: true,
        );

        await tester.pump();

        NoteListScreenRobot.expectScreenErrorVisible();

        await NoteListScreenRobot.tapOnCloseError(tester);
      },
    );
  });
}
