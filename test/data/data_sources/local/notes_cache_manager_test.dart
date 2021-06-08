import 'package:flutter_clean_bloc/data/data_sources/local/local_notes_data_source.dart';
import 'package:flutter_clean_bloc/data/data_sources/local/notes_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fakes.dart';
import '../../../helpers.dart';

void main() {
  late NotesLocalDataSource localDataSource;
  final notes = fakeExternalNotes;

  group('With notes cache manager', () {
    setUp(() {
      localDataSource = NotesCacheManager();
    });

    test(
      'When saved notes, should be able to get it back immediately',
      () async {
        final result = await localDataSource.saveNotes(notes);
        expect(result, notes);
      },
    );

    test('When saved notes, should be able to get it back', () async {
      await localDataSource.saveNotes(notes);
      final result = await localDataSource.getNotes();
      expect(result, notes);
    });

    test('When saved notes, should be able to get a specific note', () async {
      await localDataSource.saveNotes(notes);
      final result = await localDataSource.getNote(notes.first.id);
      expect(result, notes.first);
    });

    test(
      'When no notes were saved, should thrown error when getting notes',
      () async {
        expectExceptionThrown<LocalNotesCacheIsEmpty>(
          () => localDataSource.getNotes(),
        );
      },
    );

    test(
      'When no notes were saved, should thrown error when getting a note',
      () async {
        expectExceptionThrown<LocalNotesCacheIsEmpty>(
          () => localDataSource.getNote(notes.first.id),
        );
      },
    );
  });
}
