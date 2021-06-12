part of 'add_edit_note_bloc.dart';

abstract class AddEditNoteEvent
    extends BaseEvent<AddEditNoteState, AddEditNoteBloc> {
  const AddEditNoteEvent();
}

class AddEditNoteLoadEvent extends AddEditNoteEvent {
  const AddEditNoteLoadEvent({this.id});

  final String? id;

  @override
  Stream<AddEditNoteState> apply(AddEditNoteBloc bloc) async* {
    if (id != null) {
      yield AddEditNoteLoadingState(note: bloc.state.note);
      try {
        final result = await bloc._notesUseCases.getNote(id!);
        yield AddEditNoteLoadedState(note: result);
      } catch (e) {
        debugPrint(e.toString());
        yield AddEditNoteErrorState();
      }
    } else {
      yield AddEditNoteInitialState(loading: false);
    }
  }
}

class AddEditNoteSubmitEvent extends AddEditNoteEvent {
  const AddEditNoteSubmitEvent({
    required this.title,
    required this.content,
    this.id,
  });

  final String title, content;
  final String? id;

  @override
  Stream<AddEditNoteState> apply(AddEditNoteBloc bloc) async* {
    final isTitleValid = title.isValidTitle;
    final isContentValid = content.isValidContent;

    if (!isTitleValid || !isContentValid) {
      yield AddEditNoteInvalidInfoState(
        note: bloc.state.note,
        invalidTitle: !isTitleValid,
        invalidContent: !isContentValid,
      );
    } else {
      yield AddEditNoteLoadingState(note: bloc.state.note);

      try {
        Note result;
        if (id != null) {
          result = await bloc._notesUseCases.updateNote(
            id: id!,
            title: title,
            content: content,
          );
        } else {
          result = await bloc._notesUseCases.createNote(
            title: title,
            content: content,
          );
        }
        yield AddEditNoteSavedState(note: result);
      } catch (e) {
        debugPrint(e.toString());
        yield AddEditNoteErrorState();
      }
    }
  }
}
