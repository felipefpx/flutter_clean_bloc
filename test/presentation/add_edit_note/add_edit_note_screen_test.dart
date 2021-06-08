import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_clean_bloc/presentation/add_edit_note/bloc/add_edit_note_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../fakes.dart';
import 'add_edit_note_screen_robot.dart';

class MockAddEditNoteBloc extends MockBloc<AddEditNoteEvent, AddEditNoteState>
    implements AddEditNoteBloc {}

void main() {
  group('With add edit note screen', () {
    setUp(() {
      registerFallbackValue<AddEditNoteState>(AddEditNoteInitialState());
      registerFallbackValue<AddEditNoteEvent>(AddEditNoteLoadEvent());
    });

    testWidgets('should display the initial state', (tester) async {
      final mockBloc = MockAddEditNoteBloc();
      var onSavedCounter = 0, onBackCounter = 0;

      whenListen<AddEditNoteState>(
        mockBloc,
        Stream.fromIterable([]),
        initialState: AddEditNoteInitialState(),
      );

      await AddEditNoteScreenRobot.launch(
        tester,
        bloc: mockBloc,
        onSaved: () {
          onSavedCounter++;
        },
        onBack: () {
          onBackCounter++;
        },
      );

      AddEditNoteScreenRobot.expectScreenVisible(loading: true);

      expect(onSavedCounter, 0);
      expect(onBackCounter, 0);
    });

    testWidgets('should display the loading', (tester) async {
      final mockBloc = MockAddEditNoteBloc();
      var onSavedCounter = 0, onBackCounter = 0;

      whenListen<AddEditNoteState>(
        mockBloc,
        Stream.fromIterable([AddEditNoteLoadingState()]),
        initialState: AddEditNoteInitialState(),
      );

      await AddEditNoteScreenRobot.launch(
        tester,
        bloc: mockBloc,
        onSaved: () {
          onSavedCounter++;
        },
        onBack: () {
          onBackCounter++;
        },
      );

      AddEditNoteScreenRobot.expectScreenVisible(loading: true);

      expect(onSavedCounter, 0);
      expect(onBackCounter, 0);
    });

    testWidgets('should prepare a new form and create a note', (tester) async {
      final mockBloc = MockAddEditNoteBloc();
      var onSavedCounter = 0, onBackCounter = 0;

      whenListen<AddEditNoteState>(
        mockBloc,
        Stream.fromIterable([AddEditNoteInitialState(loading: false)]),
        initialState: AddEditNoteInitialState(),
      );

      await AddEditNoteScreenRobot.launch(
        tester,
        bloc: mockBloc,
        onSaved: () {
          onSavedCounter++;
        },
        onBack: () {
          onBackCounter++;
        },
      );

      AddEditNoteScreenRobot.expectScreenVisible();

      expect(onSavedCounter, 0);
      expect(onBackCounter, 0);
    });

    testWidgets('should load existing note and update it', (tester) async {
      final mockBloc = MockAddEditNoteBloc();
      final note = fakeNote;
      var onSavedCounter = 0, onBackCounter = 0;

      whenListen<AddEditNoteState>(
        mockBloc,
        Stream.fromIterable([AddEditNoteLoadedState(note: note)]),
        initialState: AddEditNoteInitialState(),
      );

      await AddEditNoteScreenRobot.launch(
        tester,
        bloc: mockBloc,
        onSaved: () {
          onSavedCounter++;
        },
        onBack: () {
          onBackCounter++;
        },
      );

      AddEditNoteScreenRobot.expectScreenVisible(note: note);

      expect(onSavedCounter, 0);
      expect(onBackCounter, 0);
    });

    testWidgets('should display error with note', (tester) async {
      final mockBloc = MockAddEditNoteBloc();
      final note = fakeNote;
      var onSavedCounter = 0, onBackCounter = 0;

      whenListen<AddEditNoteState>(
        mockBloc,
        Stream.fromIterable([AddEditNoteErrorState(note: note)]),
        initialState: AddEditNoteInitialState(),
      );

      await AddEditNoteScreenRobot.launch(
        tester,
        bloc: mockBloc,
        onSaved: () {
          onSavedCounter++;
        },
        onBack: () {
          onBackCounter++;
        },
      );
      await tester.pumpAndSettle();

      AddEditNoteScreenRobot.expectScreenErrorVisible();

      expect(onSavedCounter, 0);
      expect(onBackCounter, 0);
    });

    testWidgets('should display error without note', (tester) async {
      final mockBloc = MockAddEditNoteBloc();
      var onSavedCounter = 0, onBackCounter = 0;

      whenListen<AddEditNoteState>(
        mockBloc,
        Stream.fromIterable([AddEditNoteErrorState()]),
        initialState: AddEditNoteInitialState(),
      );

      await AddEditNoteScreenRobot.launch(
        tester,
        bloc: mockBloc,
        onSaved: () {
          onSavedCounter++;
        },
        onBack: () {
          onBackCounter++;
        },
      );
      await tester.pumpAndSettle();

      AddEditNoteScreenRobot.expectScreenVisible();
      AddEditNoteScreenRobot.expectScreenErrorVisible();
      await AddEditNoteScreenRobot.tapOnCloseError(tester);

      expect(onSavedCounter, 0);
      expect(onBackCounter, 1);
    });

    testWidgets('should display invalid title', (tester) async {
      final mockBloc = MockAddEditNoteBloc();
      var onSavedCounter = 0, onBackCounter = 0;

      whenListen<AddEditNoteState>(
        mockBloc,
        Stream.fromIterable([
          AddEditNoteInvalidInfoState(invalidTitle: true, invalidContent: false)
        ]),
        initialState: AddEditNoteInitialState(),
      );

      await AddEditNoteScreenRobot.launch(
        tester,
        bloc: mockBloc,
        onSaved: () {
          onSavedCounter++;
        },
        onBack: () {
          onBackCounter++;
        },
      );
      await tester.pumpAndSettle();

      AddEditNoteScreenRobot.expectScreenVisible();
      AddEditNoteScreenRobot.expectInvalidInfoError(
        invalidTitle: true,
        invalidContent: false,
      );

      expect(onSavedCounter, 0);
      expect(onBackCounter, 0);
    });

    testWidgets('should display invalid content', (tester) async {
      final mockBloc = MockAddEditNoteBloc();
      var onSavedCounter = 0, onBackCounter = 0;

      whenListen<AddEditNoteState>(
        mockBloc,
        Stream.fromIterable([
          AddEditNoteInvalidInfoState(invalidTitle: false, invalidContent: true)
        ]),
        initialState: AddEditNoteInitialState(),
      );

      await AddEditNoteScreenRobot.launch(
        tester,
        bloc: mockBloc,
        onSaved: () {
          onSavedCounter++;
        },
        onBack: () {
          onBackCounter++;
        },
      );
      await tester.pumpAndSettle();

      AddEditNoteScreenRobot.expectScreenVisible();
      AddEditNoteScreenRobot.expectInvalidInfoError(
        invalidTitle: false,
        invalidContent: true,
      );

      expect(onSavedCounter, 0);
      expect(onBackCounter, 0);
    });

    testWidgets('should run saved callback when saved a note', (tester) async {
      final mockBloc = MockAddEditNoteBloc();
      final note = fakeNote;
      var onSavedCounter = 0, onBackCounter = 0;

      whenListen<AddEditNoteState>(
        mockBloc,
        Stream.fromIterable([AddEditNoteSavedState(note: note)]),
        initialState: AddEditNoteInitialState(),
      );

      await AddEditNoteScreenRobot.launch(
        tester,
        bloc: mockBloc,
        onSaved: () {
          onSavedCounter++;
        },
        onBack: () {
          onBackCounter++;
        },
      );
      await tester.pumpAndSettle();

      expect(onSavedCounter, 1);
      expect(onBackCounter, 0);
    });
  });
}
