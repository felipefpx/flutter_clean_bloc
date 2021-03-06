import '../domain/models/note.dart';
import '../domain/use_cases/notes_use_cases.dart';
import 'data_sources/local/local_notes_data_source.dart';
import 'data_sources/local/local_notes_data_source_errors.dart';
import 'data_sources/remote/remote_notes_data_source.dart';
import 'models/external_note.dart';

class NotesRepository extends NotesUseCases {
  NotesRepository({
    required NotesRemoteDataSource notesRemoteDataSource,
    required NotesLocalDataSource notesLocalDataSource,
  })  : _notesRemoteDataSource = notesRemoteDataSource,
        _notesLocalDataSource = notesLocalDataSource;

  final NotesRemoteDataSource _notesRemoteDataSource;
  final NotesLocalDataSource _notesLocalDataSource;

  @override
  Stream<List<Note>> getNotes({bool ensureUpdated = false}) async* {
    if (!ensureUpdated) {
      try {
        final localNotes = await _notesLocalDataSource.getNotes();
        yield localNotes.toNotes();
      } on LocalNotesCacheIsEmpty {}
    }

    final remoteNotes = await _notesRemoteDataSource
        .getNotes()
        .then(_notesLocalDataSource.saveNotes);

    yield remoteNotes.toNotes();
  }

  @override
  Future<Note> getNote(String id) async {
    try {
      final localNotes = await _notesLocalDataSource.getNote(id);
      return localNotes.toNote();
    } on LocalNotesCacheIsEmpty {}

    final remoteNote = await _notesRemoteDataSource
        .getNote(id)
        .then((externalNote) => externalNote.toNote());

    return remoteNote;
  }

  @override
  Future<Note> createNote({
    required String title,
    required String content,
  }) =>
      _notesRemoteDataSource
          .postNote(
            title: title,
            content: content,
          )
          .then((externalNote) => externalNote.toNote());

  @override
  Future<Note> updateNote({
    required String id,
    required String title,
    required String content,
  }) =>
      _notesRemoteDataSource
          .putNote(
            id: id,
            title: title,
            content: content,
          )
          .then((externalNote) => externalNote.toNote());

  @override
  Future<void> deleteNote(String noteId) =>
      _notesRemoteDataSource.deleteNote(noteId);
}
