import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/models/note.dart';
import '../../../domain/use_cases/notes_use_cases.dart';
import '../../shared/bloc/base_bloc.dart';

part 'note_list_events.dart';

part 'note_list_states.dart';

class NoteListBloc extends BaseBloc<NoteListEvent, NoteListState> {
  NoteListBloc({required NotesUseCases notesUseCases})
      : _notesUseCases = notesUseCases,
        super(const NoteListInitialState());

  final NotesUseCases _notesUseCases;
}
