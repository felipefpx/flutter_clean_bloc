import '../models/note.dart';

abstract class NotesUseCases {
  Stream<List<Note>> getNotes({bool ensureUpdated = false});

  Future<Note> getNote(String id);

  Future<Note> createNote({
    required String title,
    required String content,
  });

  Future<Note> updateNote({
    required String id,
    required String title,
    required String content,
  });

  Future<void> deleteNote(String noteId);
}

extension NoteInfoValidator on String {
  bool get isValidTitle => isNotEmpty;
  bool get isValidContent => isNotEmpty;
}
