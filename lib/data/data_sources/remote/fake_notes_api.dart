import '../../models/external_note.dart';
import 'remote_notes_data_source.dart';

class FakeNotesApi implements NotesRemoteDataSource {
  final Map<String, ExternalNote> _notes = {};
  int _lastId = 0;

  @override
  Future<List<ExternalNote>> getNotes() async {
    await Future.delayed(Duration(seconds: 1));
    return _notes.entries.map((e) => e.value).toList();
  }

  @override
  Future<ExternalNote> postNote({
    required String title,
    required String content,
  }) async {
    await Future.delayed(Duration(seconds: 1));
    final note = ExternalNote(
      id: (_lastId++).toString(),
      title: title,
      content: content,
    );

    _notes[note.id] = note;
    return note;
  }

  @override
  Future<ExternalNote> getNote(String id) async {
    await Future.delayed(Duration(seconds: 1));
    return _notes[id]!;
  }

  @override
  Future<ExternalNote> putNote({
    required String id,
    required String title,
    required String content,
  }) async {
    await Future.delayed(Duration(seconds: 1));
    final note = ExternalNote(
      id: id.toString(),
      title: title,
      content: content,
    );

    _notes[id] = note;
    return note;
  }

  @override
  Future<void> deleteNote(String id) async {
    _notes.remove(id);
  }
}
