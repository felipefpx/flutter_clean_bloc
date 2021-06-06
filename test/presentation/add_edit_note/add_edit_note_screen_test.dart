import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_clean_bloc/presentation/add_edit_note/bloc/add_edit_note_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../fakes.dart';
import 'add_edit_note_screen_robot.dart';

class MockAddEditNoteBloc extends MockBloc<AddEditNoteEvent, AddEditNoteState>
    implements AddEditNoteBloc {}

void main() {
  late MockAddEditNoteBloc mockBloc;
  late int onSavedCounter;
  late int onBackCounter;
  final note = fakeNote;

  void _onSaved() {
    onSavedCounter++;
  }

  void _onBack() {
    onBackCounter++;
  }

  setUp(() {
    registerFallbackValue<AddEditNoteState>(AddEditNoteInitialState());
    registerFallbackValue<AddEditNoteEvent>(AddEditNoteLoadEvent());

    mockBloc = MockAddEditNoteBloc();

    onSavedCounter = 0;
    onBackCounter = 0;
  });

  testWidgets('should display the initial state', (tester) async {
    whenListen<AddEditNoteState>(
      mockBloc,
      Stream.fromIterable([]),
      initialState: AddEditNoteInitialState(),
    );

    await AddEditNoteScreenRobot.launch(
      tester,
      bloc: mockBloc,
      onSaved: _onSaved,
      onBack: _onBack,
    );

    AddEditNoteScreenRobot.expectScreenVisible(loading: true);

    expect(onSavedCounter, 0);
    expect(onBackCounter, 0);
  });

  testWidgets('should display the loading', (tester) async {
    whenListen<AddEditNoteState>(
      mockBloc,
      Stream.fromIterable([AddEditNoteLoadingState()]),
      initialState: AddEditNoteInitialState(),
    );

    await AddEditNoteScreenRobot.launch(
      tester,
      bloc: mockBloc,
      onSaved: _onSaved,
      onBack: _onBack,
    );

    AddEditNoteScreenRobot.expectScreenVisible(loading: true);

    expect(onSavedCounter, 0);
    expect(onBackCounter, 0);
  });

  testWidgets('should prepare a new form and create a note', (tester) async {
    whenListen<AddEditNoteState>(
      mockBloc,
      Stream.fromIterable([AddEditNoteInitialState(loading: false)]),
      initialState: AddEditNoteInitialState(),
    );

    await AddEditNoteScreenRobot.launch(
      tester,
      bloc: mockBloc,
      onSaved: _onSaved,
      onBack: _onBack,
    );

    AddEditNoteScreenRobot.expectScreenVisible();

    expect(onSavedCounter, 0);
    expect(onBackCounter, 0);
  });

  testWidgets('should load existing note and update it', (tester) async {
    whenListen<AddEditNoteState>(
      mockBloc,
      Stream.fromIterable([AddEditNoteLoadedState(note: note)]),
      initialState: AddEditNoteInitialState(),
    );

    await AddEditNoteScreenRobot.launch(
      tester,
      bloc: mockBloc,
      onSaved: _onSaved,
      onBack: _onBack,
    );

    AddEditNoteScreenRobot.expectScreenVisible(note: note);

    expect(onSavedCounter, 0);
    expect(onBackCounter, 0);
  });
}
