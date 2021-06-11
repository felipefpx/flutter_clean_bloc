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
        () => httpClient.post(
          Uri.parse('${NotesApi.apiBaseUrl}/notes'),
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
      'When adding a note with valid info, should get success',
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

        await NoteListScreenRobot.tapOnAdd(tester);

        AddEditNoteScreenRobot.expectScreenVisible();

        await AddEditNoteScreenRobot.typeTitle(
          tester,
          externalNotes.first.title,
        );

        await AddEditNoteScreenRobot.typeContent(
          tester,
          externalNotes.first.content,
        );

        await AddEditNoteScreenRobot.tapOnSave(tester);

        NoteListScreenRobot.expectScreenVisible(
          loading: true,
          shimmering: false,
          notes: getNotes(),
        );
      },
    );

    testWidgets(
      'When adding a note with valid info and server error, should get error',
      (tester) async {
        when(
          () => httpClient.post(
            Uri.parse('${NotesApi.apiBaseUrl}/notes'),
            headers: NotesApi.defaultHeaders,
            body: jsonEncode(
              {
                'title': externalNotes.first.title,
                'content': externalNotes.first.content,
              },
            ),
          ),
        ).thenAnswer((_) async => fakeResponse('{}', 404));

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

        await NoteListScreenRobot.tapOnAdd(tester);

        AddEditNoteScreenRobot.expectScreenVisible();

        await AddEditNoteScreenRobot.typeTitle(
          tester,
          externalNotes.first.title,
        );

        await AddEditNoteScreenRobot.typeContent(
          tester,
          externalNotes.first.content,
        );

        await AddEditNoteScreenRobot.tapOnSave(tester);

        AddEditNoteScreenRobot.expectScreenErrorVisible();

        await AddEditNoteScreenRobot.tapOnCloseError(tester);
      },
    );

    testWidgets(
      'When adding a note with invalid info, should view error',
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

        await NoteListScreenRobot.tapOnAdd(tester);

        AddEditNoteScreenRobot.expectScreenVisible();

        await AddEditNoteScreenRobot.tapOnSave(tester);

        AddEditNoteScreenRobot.expectInvalidInfoError(
          invalidTitle: true,
          invalidContent: true,
        );

        await AddEditNoteScreenRobot.tapOnBack(tester);

        NoteListScreenRobot.expectScreenVisible(
          loading: true,
          shimmering: false,
          notes: getNotes(),
        );
      },
    );
  });
}
