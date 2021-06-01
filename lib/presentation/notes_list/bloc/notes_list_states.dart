part of 'notes_list_bloc.dart';

abstract class NotesListState extends BaseState {
  const NotesListState({
    required this.notes,
    required this.loading,
    required this.shimmering,
  });

  final List<Note> notes;
  final bool loading, shimmering;

  @override
  List<Object?> get props => [notes, loading];
}

class NotesListLoadingState extends NotesListState {
  const NotesListLoadingState({
    List<Note> notes = const [],
    bool shimmering = true,
  }) : super(notes: notes, loading: true, shimmering: shimmering);
}

class NotesListInitialState extends NotesListLoadingState {
  const NotesListInitialState();
}

class NotesListLoadedState extends NotesListState {
  const NotesListLoadedState({required List<Note> notes})
      : super(notes: notes, loading: false, shimmering: false);
}

class NotesListErrorState extends NotesListState {
  const NotesListErrorState({List<Note> notes = const []})
      : super(notes: notes, loading: false, shimmering: false);
}
