part of 'notes_list_bloc.dart';

abstract class NotesListEvent extends BaseEvent<NotesListState, NotesListBloc> {
  const NotesListEvent();
}

class NotesListLoadEvent extends NotesListEvent {
  const NotesListLoadEvent();

  @override
  Stream<NotesListState> apply(NotesListBloc bloc) async* {
    yield NotesListLoadingState();

    yield* bloc._notesUseCases
        .getNotes()
        .map<NotesListState>(
          (notes) => NotesListLoadingState(notes: notes, shimmering: false),
        )
        .startWith(NotesListLoadingState())
        .doOnDone(
            () => bloc.yield(NotesListLoadedState(notes: bloc.state.notes)))
        .onErrorReturn(NotesListErrorState(notes: bloc.state.notes));
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
          await bloc._notesUseCases.getNotes(ignoreCache: true).last;

      yield NotesListLoadedState(notes: updatedNotes);
    } catch (e) {
      debugPrint(e.toString());
      yield NotesListErrorState(notes: bloc.state.notes);
    }
  }
}
