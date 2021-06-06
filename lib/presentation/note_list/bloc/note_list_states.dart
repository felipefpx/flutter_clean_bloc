part of 'note_list_bloc.dart';

abstract class NoteListState extends BaseState {
  const NoteListState({
    required this.notes,
    required this.loading,
    required this.shimmering,
  });

  final List<Note> notes;
  final bool loading, shimmering;

  @override
  List<Object?> get props => [notes, loading];
}

class NoteListLoadingState extends NoteListState {
  const NoteListLoadingState({
    List<Note> notes = const [],
    bool shimmering = true,
  }) : super(notes: notes, loading: true, shimmering: shimmering);
}

class NoteListInitialState extends NoteListLoadingState {
  const NoteListInitialState();
}

class NoteListLoadedState extends NoteListState {
  const NoteListLoadedState({required List<Note> notes})
      : super(notes: notes, loading: false, shimmering: false);
}

class NoteListErrorState extends NoteListState {
  const NoteListErrorState({List<Note> notes = const []})
      : super(notes: notes, loading: false, shimmering: false);
}
