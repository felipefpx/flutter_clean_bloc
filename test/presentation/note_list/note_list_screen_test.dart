import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_clean_bloc/presentation/note_list/bloc/note_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../fakes.dart';
import 'note_list_screen_robot.dart';

class MockNoteListBloc extends MockBloc<NoteListEvent, NoteListState>
    implements NoteListBloc {}

void main() {
  group('With note list screen', () {
    setUp(() {
      registerFallbackValue<NoteListState>(NoteListInitialState());
      registerFallbackValue<NoteListEvent>(NoteListLoadEvent());
    });

    testWidgets('should display the initial state', (tester) async {
      final mockBloc = MockNoteListBloc();
      final onEditNoteHistory = <String>[];
      var onAddNewNoteCounter = 0, onBackCounter = 0;

      whenListen<NoteListState>(
        mockBloc,
        Stream.fromIterable([]),
        initialState: NoteListInitialState(),
      );

      await NoteListScreenRobot.launch(
        tester,
        bloc: mockBloc,
        onAddNewNote: () async {
          onAddNewNoteCounter++;
        },
        onEditNote: (id) async {
          onEditNoteHistory.add(id);
        },
        onBack: () {
          onBackCounter++;
        },
      );

      NoteListScreenRobot.expectScreenVisible(loading: true, shimmering: true);

      expect(onEditNoteHistory.isEmpty, isTrue);
      expect(onAddNewNoteCounter, 0);
      expect(onBackCounter, 0);
    });

    testWidgets('should display the loading state', (tester) async {
      final mockBloc = MockNoteListBloc();
      final onEditNoteHistory = <String>[];
      final notes = fakeNotes;
      var onAddNewNoteCounter = 0, onBackCounter = 0;

      whenListen<NoteListState>(
        mockBloc,
        Stream.fromIterable([
          NoteListLoadingState(
            shimmering: false,
            notes: notes,
          ),
        ]),
        initialState: NoteListInitialState(),
      );

      await NoteListScreenRobot.launch(
        tester,
        bloc: mockBloc,
        onAddNewNote: () async {
          onAddNewNoteCounter++;
        },
        onEditNote: (id) async {
          onEditNoteHistory.add(id);
        },
        onBack: () {
          onBackCounter++;
        },
      );

      NoteListScreenRobot.expectScreenVisible(
        loading: true,
        shimmering: false,
        notes: notes,
      );

      expect(onEditNoteHistory.isEmpty, isTrue);
      expect(onAddNewNoteCounter, 0);
      expect(onBackCounter, 0);
    });

    testWidgets('should display the empty state', (tester) async {
      final mockBloc = MockNoteListBloc();
      final onEditNoteHistory = <String>[];
      var onAddNewNoteCounter = 0, onBackCounter = 0;

      whenListen<NoteListState>(
        mockBloc,
        Stream.fromIterable([NoteListLoadedState(notes: [])]),
        initialState: NoteListInitialState(),
      );

      await NoteListScreenRobot.launch(
        tester,
        bloc: mockBloc,
        onAddNewNote: () async {
          onAddNewNoteCounter++;
        },
        onEditNote: (id) async {
          onEditNoteHistory.add(id);
        },
        onBack: () {
          onBackCounter++;
        },
      );

      NoteListScreenRobot.expectScreenVisible(
        loading: false,
        shimmering: false,
      );

      expect(onEditNoteHistory.isEmpty, isTrue);
      expect(onAddNewNoteCounter, 0);
      expect(onBackCounter, 0);
    });

    testWidgets(
      'on edit notes should invoke on edit note callback',
      (tester) async {
        final mockBloc = MockNoteListBloc();
        final notes = fakeNotes;
        final onEditNoteHistory = <String>[];
        var onAddNewNoteCounter = 0, onBackCounter = 0;

        whenListen<NoteListState>(
          mockBloc,
          Stream.fromIterable([NoteListLoadedState(notes: notes)]),
          initialState: NoteListInitialState(),
        );

        await NoteListScreenRobot.launch(
          tester,
          bloc: mockBloc,
          onAddNewNote: () async {
            onAddNewNoteCounter++;
          },
          onEditNote: (id) async {
            onEditNoteHistory.add(id);
          },
          onBack: () {
            onBackCounter++;
          },
          awaitSettled: true,
        );

        NoteListScreenRobot.expectScreenVisible(
          loading: false,
          shimmering: false,
          notes: notes,
        );

        await NoteListScreenRobot.tapOnEdit(tester, notes.last);

        expect(onEditNoteHistory.length, 1);
        expect(onEditNoteHistory.first, notes.last.id);
        expect(onAddNewNoteCounter, 0);
        expect(onBackCounter, 0);
      },
    );

    testWidgets(
      'on add note should invoke on add note callback',
      (tester) async {
        final mockBloc = MockNoteListBloc();
        final notes = fakeNotes;
        final onEditNoteHistory = <String>[];
        var onAddNewNoteCounter = 0, onBackCounter = 0;

        whenListen<NoteListState>(
          mockBloc,
          Stream.fromIterable([NoteListLoadedState(notes: notes)]),
          initialState: NoteListInitialState(),
        );

        await NoteListScreenRobot.launch(
          tester,
          bloc: mockBloc,
          onAddNewNote: () async {
            onAddNewNoteCounter++;
          },
          onEditNote: (id) async {
            onEditNoteHistory.add(id);
          },
          onBack: () {
            onBackCounter++;
          },
          awaitSettled: true,
        );

        NoteListScreenRobot.expectScreenVisible(
          loading: false,
          shimmering: false,
          notes: notes,
        );

        await NoteListScreenRobot.tapOnAdd(tester);

        expect(onEditNoteHistory.isEmpty, isTrue);
        expect(onAddNewNoteCounter, 1);
        expect(onBackCounter, 0);
      },
    );
  });
}
