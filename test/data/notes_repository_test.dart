import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_clean_bloc/data/data_sources/local/local_notes_data_source.dart';
import 'package:flutter_clean_bloc/data/data_sources/remote/remote_notes_data_source.dart';
import 'package:flutter_clean_bloc/data/models/external_note.dart';
import 'package:flutter_clean_bloc/data/notes_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes.dart';

class MockNotesLocalDataSource extends Mock implements NotesLocalDataSource {}

class MockNotesRemoteDataSource extends Mock implements NotesRemoteDataSource {}

void main() {
  final localExternalNotes = fakeExternalNotes;
  final localNotes = localExternalNotes.map((note) => note.toNote()).toList();
  final remoteExternalNotes = fakeExternalNotes;
  final remoteNotes = remoteExternalNotes.map((note) => note.toNote()).toList();

  group('With notes repository', () {
    late NotesRepository repository;
    late NotesLocalDataSource mockLocalDs;
    late NotesRemoteDataSource mockRemoteDs;

    setUp(() {
      mockLocalDs = MockNotesLocalDataSource();
      mockRemoteDs = MockNotesRemoteDataSource();
      repository = NotesRepository(
        notesRemoteDataSource: mockRemoteDs,
        notesLocalDataSource: mockLocalDs,
      );
    });

    tearDown(() {
      reset(mockLocalDs);
      reset(mockRemoteDs);
    });

    test('When getting notes with empty cache, should return remote', () async {
      when(() => mockLocalDs.getNotes()).thenThrow(LocalNotesCacheIsEmpty());
      when(() => mockLocalDs.saveNotes(any())).thenAnswer(
          (invocation) async => invocation.positionalArguments.first);
      when(() => mockRemoteDs.getNotes())
          .thenAnswer((_) async => remoteExternalNotes);

      final result = await repository.getNotes().toList();
      expect(
        result,
        [remoteNotes],
      );

      verify(() => mockLocalDs.getNotes());
      verify(() => mockRemoteDs.getNotes());
    });

    test('When getting notes ignoring cache, should return remote', () async {
      when(() => mockLocalDs.getNotes()).thenThrow(LocalNotesCacheIsEmpty());
      when(() => mockLocalDs.saveNotes(any())).thenAnswer(
          (invocation) async => invocation.positionalArguments.first);
      when(() => mockRemoteDs.getNotes())
          .thenAnswer((_) async => remoteExternalNotes);

      final result = await repository.getNotes(ensureUpdated: true).toList();
      expect(
        result,
        [remoteNotes],
      );

      verifyNever(() => mockLocalDs.getNotes());
      verify(() => mockRemoteDs.getNotes());
    });

    test(
      'When getting notes with cache, should return both remote and local',
      () async {
        when(() => mockLocalDs.getNotes())
            .thenAnswer((_) async => localExternalNotes);
        when(() => mockLocalDs.saveNotes(any())).thenAnswer(
            (invocation) async => invocation.positionalArguments.first);
        when(() => mockRemoteDs.getNotes())
            .thenAnswer((_) async => remoteExternalNotes);

        final result = await repository.getNotes().toList();
        expect(
          result,
          [localNotes, remoteNotes],
        );

        verify(() => mockLocalDs.getNotes());
        verify(() => mockRemoteDs.getNotes());
      },
    );

    test(
      'When getting note with cache, should return local',
      () async {
        when(() => mockLocalDs.getNote(any()))
            .thenAnswer((_) async => localExternalNotes.first);
        when(() => mockRemoteDs.getNote(any()))
            .thenAnswer((_) async => remoteExternalNotes.first);

        final result = await repository.getNote(localExternalNotes.first.id);
        expect(
          result,
          localNotes.first,
        );

        verify(() => mockLocalDs.getNote(localExternalNotes.first.id));
        verifyNever(() => mockRemoteDs.getNote(localExternalNotes.first.id));
      },
    );

    test(
      'When getting note without cache, should return remote',
      () async {
        when(() => mockLocalDs.getNote(any()))
            .thenThrow(LocalNotesCacheIsEmpty());
        when(() => mockRemoteDs.getNote(any()))
            .thenAnswer((_) async => remoteExternalNotes.first);

        final result = await repository.getNote(localExternalNotes.first.id);
        expect(
          result,
          remoteNotes.first,
        );

        verify(() => mockLocalDs.getNote(localExternalNotes.first.id));
        verify(() => mockRemoteDs.getNote(localExternalNotes.first.id));
      },
    );

    test(
      'When removing a note, should be successful removed',
      () async {
        when(() => mockRemoteDs.deleteNote(any())).thenAnswer((_) async {});
        await repository.deleteNote(localExternalNotes.first.id);
        verify(() => mockRemoteDs.deleteNote(localExternalNotes.first.id));
      },
    );

    test(
      'When updating a note, should be successful updated',
      () async {
        when(
          () => mockRemoteDs.putNote(
            id: any(named: 'id'),
            title: any(named: 'title'),
            content: any(named: 'content'),
          ),
        ).thenAnswer((_) async => remoteExternalNotes.first);

        final result = await repository.updateNote(
          id: localExternalNotes.first.id,
          title: localExternalNotes.first.title,
          content: localExternalNotes.first.content,
        );

        expect(result, remoteNotes.first);

        verify(
          () => mockRemoteDs.putNote(
            id: localExternalNotes.first.id,
            title: localExternalNotes.first.title,
            content: localExternalNotes.first.content,
          ),
        );
      },
    );

    test(
      'When creating a note, should be successful created',
      () async {
        when(
          () => mockRemoteDs.postNote(
            title: any(named: 'title'),
            content: any(named: 'content'),
          ),
        ).thenAnswer((_) async => remoteExternalNotes.first);

        final result = await repository.createNote(
          title: localExternalNotes.first.title,
          content: localExternalNotes.first.content,
        );

        expect(result, remoteNotes.first);

        verify(
          () => mockRemoteDs.postNote(
            title: localExternalNotes.first.title,
            content: localExternalNotes.first.content,
          ),
        );
      },
    );
  });
}
