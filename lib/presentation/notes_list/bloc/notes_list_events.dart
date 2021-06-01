part of 'notes_list_bloc.dart';

abstract class NotesListEvent extends BaseEvent<NotesListState, NotesListBloc> {
  const NotesListEvent();
}

class NotesListLoadEvent extends NotesListEvent {
  const NotesListLoadEvent();

  @override
  Stream<NotesListState> apply(NotesListBloc bloc) async* {
    yield NotesListLoadingState();

    try {
      yield* bloc._notesUseCases.getNotes().map(
          (notes) => NotesListLoadingState(notes: notes, shimmering: false));

      yield NotesListLoadedState(notes: bloc.state.notes);
    } catch (e) {
      debugPrint(e.toString());
      yield NotesListErrorState(notes: bloc.state.notes);
    }
  }
}

class DeleteNoteEvent extends NotesListEvent {
  const DeleteNoteEvent(this.noteId);

  final String noteId;

  @override
  Stream<NotesListState> apply(NotesListBloc bloc) async* {
    yield NotesListLoadingState(notes: bloc.state.notes);

    try {
      await bloc._notesUseCases.deleteNote(noteId);

      final updatedNotes =
          await bloc._notesUseCases.getNotes(ignoreLocal: true).last;

      yield NotesListLoadedState(notes: updatedNotes);
    } catch (e) {
      debugPrint(e.toString());
      yield NotesListErrorState(notes: bloc.state.notes);
    }
  }
}
