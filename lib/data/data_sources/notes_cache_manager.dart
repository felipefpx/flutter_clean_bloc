import '../models/external_note.dart';

abstract class NotesLocalDataSource {
  Future<List<ExternalNote>> getNotes();
  Future<ExternalNote> getNote(String id);
  Future<List<ExternalNote>> saveNotes(List<ExternalNote> notes);
}

class LocalNotesCacheIsEmpty implements Exception {}

class NotesCacheManager implements NotesLocalDataSource {
  List<ExternalNote>? _notes;

  Future<List<ExternalNote>> getNotes() async {
    if (_notes != null) {
      return _notes!;
    }
    throw LocalNotesCacheIsEmpty();
  }

  Future<ExternalNote> getNote(String id) async {
    final note = _notes?.firstWhere((note) => note.id == id);
    if (note != null) {
      return note;
    }
    throw LocalNotesCacheIsEmpty();
  }

  Future<List<ExternalNote>> saveNotes(List<ExternalNote> notes) async {
    _notes = notes;
    return await getNotes();
  }
}
