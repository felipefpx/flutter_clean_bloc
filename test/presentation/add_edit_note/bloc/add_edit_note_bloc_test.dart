import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_clean_bloc/domain/models/note.dart';
import 'package:flutter_clean_bloc/domain/use_cases/notes_use_cases.dart';
import 'package:flutter_clean_bloc/presentation/add_edit_note/bloc/add_edit_note_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fakes.dart';
import '../../mocks.dart';

void main() {
  late NotesUseCases useCases;
  late Note note;

  group('Notes add edit bloc with successful requests', () {
    setUp(() {
      useCases = MockNotesUseCases();
      note = fakeNote;

      when(() => useCases.getNote(any())).thenAnswer((_) async => note);

      when(
        () => useCases.createNote(
          title: any(named: 'title'),
          content: any(named: 'content'),
        ),
      ).thenAnswer((_) async => note);

      when(
        () => useCases.updateNote(
          id: any(named: 'id'),
          title: any(named: 'title'),
          content: any(named: 'content'),
        ),
      ).thenAnswer((_) async => note);
    });

    tearDown(() {
      reset(useCases);
    });

    blocTest<AddEditNoteBloc, AddEditNoteState>(
      'when loading without id, should disable loading',
      build: () => AddEditNoteBloc(notesUseCases: useCases),
      act: (bloc) => bloc.add(AddEditNoteLoadEvent()),
      expect: () {
        verifyNever(() => useCases.getNote(any()));
        return [AddEditNoteInitialState(loading: false)];
      },
    );

    blocTest<AddEditNoteBloc, AddEditNoteState>(
      'when loading with id, should load the note',
      build: () => AddEditNoteBloc(notesUseCases: useCases),
      act: (bloc) => bloc.add(AddEditNoteLoadEvent(id: note.id)),
      expect: () {
        verify(() => useCases.getNote(note.id)).called(1);
        return [
          AddEditNoteLoadingState(),
          AddEditNoteLoadedState(note: note),
        ];
      },
    );

    blocTest<AddEditNoteBloc, AddEditNoteState>(
      'when submiting a note without id, should create the note',
      build: () => AddEditNoteBloc(notesUseCases: useCases),
      act: (bloc) => bloc.add(AddEditNoteSubmitEvent(
        title: note.title,
        content: note.content,
      )),
      expect: () {
        verify(
          () => useCases.createNote(
            title: note.title,
            content: note.content,
          ),
        ).called(1);
        return [
          AddEditNoteLoadingState(),
          AddEditNoteSavedState(note: note),
        ];
      },
    );

    blocTest<AddEditNoteBloc, AddEditNoteState>(
      'when submiting a note with id, should update the note',
      build: () => AddEditNoteBloc(notesUseCases: useCases),
      act: (bloc) => bloc.add(AddEditNoteSubmitEvent(
        id: note.id,
        title: note.title,
        content: note.content,
      )),
      expect: () {
        verify(
          () => useCases.updateNote(
            id: note.id,
            title: note.title,
            content: note.content,
          ),
        ).called(1);
        return [
          AddEditNoteLoadingState(),
          AddEditNoteSavedState(note: note),
        ];
      },
    );
  });

  group('Notes add edit bloc with errors', () {
    setUp(() {
      useCases = MockNotesUseCases();
      note = fakeNote;

      when(() => useCases.getNote(any())).thenAnswer((_) async {
        throw Exception('Failed');
      });

      when(
        () => useCases.createNote(
          title: any(named: 'title'),
          content: any(named: 'content'),
        ),
      ).thenAnswer((_) async {
        throw Exception('Failed');
      });

      when(
        () => useCases.updateNote(
          id: any(named: 'id'),
          title: any(named: 'title'),
          content: any(named: 'content'),
        ),
      ).thenAnswer((_) async {
        throw Exception('Failed');
      });
    });

    tearDown(() {
      reset(useCases);
    });

    blocTest<AddEditNoteBloc, AddEditNoteState>(
      'when loading with id, should emit an error',
      build: () => AddEditNoteBloc(notesUseCases: useCases),
      act: (bloc) => bloc.add(AddEditNoteLoadEvent(id: note.id)),
      expect: () {
        verify(() => useCases.getNote(note.id)).called(1);
        return [
          AddEditNoteLoadingState(),
          AddEditNoteErrorState(),
        ];
      },
    );

    blocTest<AddEditNoteBloc, AddEditNoteState>(
      'when submiting a note without id, should return error',
      build: () => AddEditNoteBloc(notesUseCases: useCases),
      act: (bloc) => bloc.add(AddEditNoteSubmitEvent(
        title: note.title,
        content: note.content,
      )),
      expect: () {
        verify(
          () => useCases.createNote(
            title: note.title,
            content: note.content,
          ),
        ).called(1);
        return [
          AddEditNoteLoadingState(),
          AddEditNoteErrorState(),
        ];
      },
    );

    blocTest<AddEditNoteBloc, AddEditNoteState>(
      'when submiting a note without id with invalid title, '
      'should return error',
      build: () => AddEditNoteBloc(notesUseCases: useCases),
      act: (bloc) => bloc.add(AddEditNoteSubmitEvent(
        title: '',
        content: note.content,
      )),
      expect: () {
        return [
          AddEditNoteInvalidInfoState(
            invalidTitle: true,
            invalidContent: false,
          ),
        ];
      },
    );

    blocTest<AddEditNoteBloc, AddEditNoteState>(
      'when submiting a note without id with invalid content, '
      'should return error',
      build: () => AddEditNoteBloc(notesUseCases: useCases),
      act: (bloc) => bloc.add(AddEditNoteSubmitEvent(
        title: note.title,
        content: '',
      )),
      expect: () {
        return [
          AddEditNoteInvalidInfoState(
            invalidTitle: false,
            invalidContent: true,
          ),
        ];
      },
    );

    blocTest<AddEditNoteBloc, AddEditNoteState>(
      'when submiting a note with id, should emit error',
      build: () => AddEditNoteBloc(notesUseCases: useCases),
      act: (bloc) => bloc.add(AddEditNoteSubmitEvent(
        id: note.id,
        title: note.title,
        content: note.content,
      )),
      expect: () {
        verify(
          () => useCases.updateNote(
            id: note.id,
            title: note.title,
            content: note.content,
          ),
        ).called(1);
        return [
          AddEditNoteLoadingState(),
          AddEditNoteErrorState(),
        ];
      },
    );

    blocTest<AddEditNoteBloc, AddEditNoteState>(
      'when submiting a note with id and invalid title, should emit error',
      build: () => AddEditNoteBloc(notesUseCases: useCases),
      act: (bloc) => bloc.add(AddEditNoteSubmitEvent(
        id: note.id,
        title: '',
        content: note.content,
      )),
      expect: () {
        return [
          AddEditNoteInvalidInfoState(
            invalidTitle: true,
            invalidContent: false,
          ),
        ];
      },
    );

    blocTest<AddEditNoteBloc, AddEditNoteState>(
      'when submiting a note with id and invalid content, should emit error',
      build: () => AddEditNoteBloc(notesUseCases: useCases),
      act: (bloc) => bloc.add(AddEditNoteSubmitEvent(
        id: note.id,
        title: note.title,
        content: '',
      )),
      expect: () {
        return [
          AddEditNoteInvalidInfoState(
            invalidTitle: false,
            invalidContent: true,
          ),
        ];
      },
    );
  });
}
