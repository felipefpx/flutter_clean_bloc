import '../../models/external_note.dart';

abstract class NotesRemoteDataSource {
  Future<List<ExternalNote>> getNotes();

  Future<ExternalNote> postNote({
    required String title,
    required String content,
  });

  Future<ExternalNote> putNote({
    required String id,
    required String title,
    required String content,
  });

  Future<ExternalNote> getNote(String id);

  Future<void> deleteNote(String id);
}
