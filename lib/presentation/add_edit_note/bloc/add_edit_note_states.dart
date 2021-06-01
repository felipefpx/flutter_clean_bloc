part of 'add_edit_note_bloc.dart';

abstract class AddEditNoteState extends BaseState {
  const AddEditNoteState({required this.loading, this.note});

  final bool loading;
  final Note? note;

  @override
  List<Object?> get props => [loading, note];
}

class AddEditNoteInitialState extends AddEditNoteState {
  const AddEditNoteInitialState() : super(loading: true);
}

class AddEditNoteLoadingState extends AddEditNoteState {
  const AddEditNoteLoadingState({Note? note})
      : super(loading: true, note: note);
}

class AddEditNoteLoadedState extends AddEditNoteState {
  const AddEditNoteLoadedState({required Note note})
      : super(loading: false, note: note);
}

class AddEditNoteSavedState extends AddEditNoteState {
  const AddEditNoteSavedState({required Note note})
      : super(loading: false, note: note);
}

class AddEditNoteInvalidInfoState extends AddEditNoteState {
  const AddEditNoteInvalidInfoState({
    required Note? note,
    required this.invalidTitle,
    required this.invalidContent,
  }) : super(loading: false, note: note);

  final bool invalidTitle, invalidContent;

  @override
  List<Object?> get props => [
        ...super.props,
        invalidTitle,
        invalidContent,
      ];
}

class AddEditNoteErrorState extends AddEditNoteState {
  const AddEditNoteErrorState({Note? note, this.onRetry})
      : super(loading: false, note: note);

  final VoidCallback? onRetry;
}
