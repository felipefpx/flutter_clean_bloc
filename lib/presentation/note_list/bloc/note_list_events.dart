part of 'note_list_bloc.dart';

abstract class NoteListEvent extends BaseEvent<NoteListState, NoteListBloc> {
  const NoteListEvent();
}

class NoteListLoadEvent extends NoteListEvent {
  const NoteListLoadEvent();

  @override
  Stream<NoteListState> apply(NoteListBloc bloc) => bloc._notesUseCases
      .getNotes()
      .map<NoteListState>(
        (notes) => NoteListLoadingState(notes: notes, shimmering: false),
      )
      .startWith(NoteListLoadingState())
      .doOnDone(() => bloc.emit(NoteListLoadedState(notes: bloc.state.notes)))
      .onErrorReturn(NoteListErrorState(notes: bloc.state.notes));
}

class DeleteNoteEvent extends NoteListEvent {
  const DeleteNoteEvent(this.noteId);

  final String noteId;

  @override
  Stream<NoteListState> apply(NoteListBloc bloc) async* {
    yield NoteListLoadingState(notes: bloc.state.notes);

    try {
      await bloc._notesUseCases.deleteNote(noteId);

      final updatedNotes =
          await bloc._notesUseCases.getNotes(ensureUpdated: true).last;

      yield NoteListLoadedState(notes: updatedNotes);
    } catch (e) {
      debugPrint(e.toString());
      yield NoteListErrorState(notes: bloc.state.notes);
    }
  }
}
