import 'package:flutter/foundation.dart';

import '../../../domain/models/note.dart';
import '../../../domain/use_cases/notes_use_cases.dart';
import '../../shared/bloc/base_bloc.dart';

part 'notes_list_events.dart';
part 'notes_list_states.dart';

class NotesListBloc extends BaseBloc<NotesListState, NotesListEvent> {
  NotesListBloc({required NotesUseCases notesUseCases})
      : _notesUseCases = notesUseCases,
        super(const NotesListInitialState());

  final NotesUseCases _notesUseCases;
}