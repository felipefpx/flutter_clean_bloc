import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_clean_bloc/presentation/notes_list/bloc/note_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

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
  });
}
