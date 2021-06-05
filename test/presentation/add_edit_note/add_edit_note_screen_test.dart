import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_clean_bloc/presentation/add_Edit_note/bloc/add_edit_note_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../fakes.dart';
import 'add_edit_note_screen_robot.dart';

class MockAddEditBloc extends MockBloc<AddEditNoteEvent, AddEditNoteState>
    implements AddEditNoteBloc {}

void main() {
  late MockAddEditBloc mockBloc;
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

    mockBloc = MockAddEditBloc();

    onSavedCounter = 0;
    onBackCounter = 0;
  });

  testWidgets('should display the loading', (tester) async {
    when(() => mockBloc.state).thenReturn(AddEditNoteLoadingState());

    await AddEditNoteScreenRobot.launch(
      tester,
      bloc: mockBloc,
      onSaved: _onSaved,
      onBack: _onBack,
    );

    AddEditNoteScreenRobot.expectScreenVisible(loading: true);

    await AddEditNoteScreenRobot.tapOnBack(tester);

    expect(onSavedCounter, 0);
    expect(onBackCounter, 1);
  });

  testWidgets('should prepare a new form and create a note', (tester) async {
    when(() => mockBloc.state)
        .thenReturn(AddEditNoteInitialState(loading: false));

    await AddEditNoteScreenRobot.launch(
      tester,
      bloc: mockBloc,
      onSaved: _onSaved,
      onBack: _onBack,
    );

    AddEditNoteScreenRobot.expectScreenVisible();
    await AddEditNoteScreenRobot.tapOnBack(tester);

    expect(onSavedCounter, 0);
    expect(onBackCounter, 1);
  });

  testWidgets('should load existing note and update it', (tester) async {
    when(() => mockBloc.state).thenReturn(AddEditNoteLoadedState(note: note));

    await AddEditNoteScreenRobot.launch(
      tester,
      bloc: mockBloc,
      onSaved: _onSaved,
      onBack: _onBack,
    );

    AddEditNoteScreenRobot.expectScreenVisible(note: note);
    await AddEditNoteScreenRobot.tapOnBack(tester);

    expect(onSavedCounter, 0);
    expect(onBackCounter, 1);
  });
}
