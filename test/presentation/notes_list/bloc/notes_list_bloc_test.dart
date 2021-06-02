import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_clean_bloc/domain/models/note.dart';
import 'package:flutter_clean_bloc/domain/use_cases/notes_use_cases.dart';
import 'package:flutter_clean_bloc/presentation/notes_list/bloc/notes_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fakes.dart';
import '../../mocks.dart';

void main() {
  late NotesUseCases useCases;
  late List<Note> localNotes, remoteNotes;

  group('Notes list bloc with successful requests', () {
    setUp(() {
      useCases = MockNotesUseCases();
      localNotes = fakeNotes;
      remoteNotes = fakeNotes;

      when(() => useCases.getNotes(ignoreCache: false)).thenAnswer((_) async* {
        yield localNotes;
        yield remoteNotes;
      });

      when(() => useCases.getNotes(ignoreCache: true)).thenAnswer((_) async* {
        yield remoteNotes;
      });

      when(() => useCases.deleteNote(any())).thenAnswer((_) async {});
    });

    tearDown(() {
      reset(useCases);
    });

    blocTest<NotesListBloc, NotesListState>(
      'should emit local and remote notes',
      build: () => NotesListBloc(notesUseCases: useCases),
      act: (bloc) => bloc.add(NotesListLoadEvent()),
      expect: () {
        verify(() => useCases.getNotes(ignoreCache: false)).called(1);
        return [
          NotesListLoadingState(),
          NotesListLoadingState(notes: localNotes, shimmering: false),
          NotesListLoadingState(notes: remoteNotes, shimmering: false),
          NotesListLoadedState(notes: remoteNotes),
        ];
      },
    );

    blocTest<NotesListBloc, NotesListState>(
      'should emit remote notes when deleting a note',
      build: () => NotesListBloc(notesUseCases: useCases),
      act: (bloc) => bloc.add(DeleteNoteEvent(localNotes.first.id)),
      expect: () {
        verify(() => useCases.deleteNote(localNotes.first.id)).called(1);
        verify(() => useCases.getNotes(ignoreCache: true)).called(1);
        return [
          NotesListLoadingState(),
          NotesListLoadedState(notes: remoteNotes),
        ];
      },
    );
  });

  group('Notes list bloc with request failures', () {
    setUp(() {
      useCases = MockNotesUseCases();
      localNotes = fakeNotes;
      remoteNotes = fakeNotes;

      when(() => useCases.getNotes(ignoreCache: false))
          .thenAnswer((_) => Stream.error(Exception('Failed')));

      when(() => useCases.getNotes(ignoreCache: true))
          .thenAnswer((_) => Stream.error(Exception('Failed')));

      when(() => useCases.deleteNote(any())).thenAnswer((_) async {
        throw Exception('Failed');
      });
    });

    tearDown(() {
      reset(useCases);
    });

    blocTest<NotesListBloc, NotesListState>(
      'should emit error when loading notes',
      build: () => NotesListBloc(notesUseCases: useCases),
      act: (bloc) => bloc.add(NotesListLoadEvent()),
      expect: () {
        verify(() => useCases.getNotes(ignoreCache: false)).called(1);
        return [
          NotesListLoadingState(),
          NotesListErrorState(notes: []),
        ];
      },
    );

    blocTest<NotesListBloc, NotesListState>(
      'should emit error when deleting a note',
      build: () => NotesListBloc(notesUseCases: useCases),
      act: (bloc) => bloc.add(DeleteNoteEvent(localNotes.first.id)),
      expect: () {
        verify(() => useCases.deleteNote(localNotes.first.id)).called(1);
        verifyNever(() => useCases.getNotes(ignoreCache: true));
        return [
          NotesListLoadingState(),
          NotesListErrorState(notes: []),
        ];
      },
    );
  });
}
