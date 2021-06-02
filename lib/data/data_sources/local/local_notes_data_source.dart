import '../../models/external_note.dart';

abstract class NotesLocalDataSource {
  Future<List<ExternalNote>> getNotes();
  Future<ExternalNote> getNote(String id);
  Future<List<ExternalNote>> saveNotes(List<ExternalNote> notes);
}

class LocalNotesCacheIsEmpty implements Exception {}
