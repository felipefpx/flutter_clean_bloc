import 'package:flutter/foundation.dart';

import '../../../domain/models/note.dart';
import '../../../domain/use_cases/notes_use_cases.dart';
import '../../shared/bloc/base_bloc.dart';

part 'add_edit_note_events.dart';

part 'add_edit_note_states.dart';

class AddEditNoteBloc extends BaseBloc<AddEditNoteEvent, AddEditNoteState> {
  AddEditNoteBloc({required NotesUseCases notesUseCases})
      : _notesUseCases = notesUseCases,
        super(const AddEditNoteInitialState());

  final NotesUseCases _notesUseCases;
}
