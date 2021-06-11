import 'dart:convert';

import 'package:flutter_clean_bloc/data/data_sources/remote/notes_api.dart';
import 'package:flutter_clean_bloc/data/models/external_note.dart';
import 'package:flutter_clean_bloc/domain/models/note.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../fakes.dart';
import '../helpers.dart';
import '../presentation/add_edit_note/add_edit_note_screen_robot.dart';
import '../presentation/mocks.dart';
import '../presentation/note_list/note_list_screen_robot.dart';

void main() {
  late http.Client httpClient;
  final externalNotes = fakeExternalNotes;
  List<Note> getNotes() =>
      externalNotes.map((extNote) => extNote.toNote()).toList();

  group('With the app and loaded notes', () {
    setUp(() {
      httpClient = MockHttpClient();

      when(
        () => httpClient.get(
          Uri.parse('${NotesApi.apiBaseUrl}/notes'),
          headers: NotesApi.defaultHeaders,
        ),
      ).thenAnswer((_) async => fakeResponse(jsonEncode(externalNotes), 200));

      when(
        () => httpClient.get(
          Uri.parse('${NotesApi.apiBaseUrl}/notes/${externalNotes.first.id}'),
          headers: NotesApi.defaultHeaders,
        ),
      ).thenAnswer(
          (_) async => fakeResponse(jsonEncode(externalNotes.first), 200));

      when(
        () => httpClient.put(
          Uri.parse('${NotesApi.apiBaseUrl}/notes/${externalNotes.first.id}'),
          headers: NotesApi.defaultHeaders,
          body: jsonEncode(
            {
              'title': externalNotes.first.title,
              'content': externalNotes.first.content,
            },
          ),
        ),
      ).thenAnswer(
          (_) async => fakeResponse(jsonEncode(externalNotes.first), 200));
    });

    tearDown(() {
      reset(httpClient);
    });

    testWidgets(
      'When editing a note with valid info, should get success',
      (tester) async {
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

        await NoteListScreenRobot.tapOnEdit(tester, getNotes().first);

        AddEditNoteScreenRobot.expectScreenVisible(note: getNotes().first);

        await AddEditNoteScreenRobot.tapOnSave(tester);

        NoteListScreenRobot.expectScreenVisible(
          loading: true,
          shimmering: false,
          notes: getNotes(),
        );
      },
    );

    testWidgets(
      'When editing a note with valid info and server error, should get error',
      (tester) async {
        when(
          () => httpClient.put(
            Uri.parse('${NotesApi.apiBaseUrl}/notes/${externalNotes.first.id}'),
            headers: NotesApi.defaultHeaders,
            body: jsonEncode(
              {
                'title': externalNotes.first.title,
                'content': externalNotes.first.content,
              },
            ),
          ),
        ).thenAnswer((_) async => fakeResponse('{}', 422));

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

        await NoteListScreenRobot.tapOnEdit(tester, getNotes().first);

        AddEditNoteScreenRobot.expectScreenVisible(note: getNotes().first);

        await AddEditNoteScreenRobot.tapOnSave(tester);

        AddEditNoteScreenRobot.expectScreenErrorVisible();

        await AddEditNoteScreenRobot.tapOnCloseError(tester);
      },
    );
  });
}
