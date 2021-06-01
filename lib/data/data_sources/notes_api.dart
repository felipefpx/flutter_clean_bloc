import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/external_note.dart';

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

class NotesApi implements NotesRemoteDataSource {
  NotesApi({required http.Client httpClient}) : _httpClient = httpClient;

  static const apiBaseUrl = 'http://127.0.0.1:8080';

  final http.Client _httpClient;

  @override
  Future<List<ExternalNote>> getNotes() => _httpClient
      .get(Uri.parse('$apiBaseUrl/notes'))
      .then((response) => jsonDecode(response.body))
      .then(
        (json) async => (json as List<dynamic>)
            .map((e) => ExternalNote.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  Future<ExternalNote> postNote({
    required String title,
    required String content,
  }) =>
      _httpClient
          .post(
            Uri.parse('$apiBaseUrl/notes'),
            body: jsonEncode(
              {
                'title': title,
                'content': content,
              },
            ),
          )
          .then((response) => jsonDecode(response.body))
          .then((json) => ExternalNote.fromJson(json));

  @override
  Future<ExternalNote> getNote(String id) => _httpClient
      .get(Uri.parse('$apiBaseUrl/notes/$id'))
      .then((response) => jsonDecode(response.body))
      .then((json) => ExternalNote.fromJson(json));

  @override
  Future<ExternalNote> putNote({
    required String id,
    required String title,
    required String content,
  }) =>
      _httpClient
          .put(
            Uri.parse('$apiBaseUrl/notes/$id'),
            body: jsonEncode(
              {
                'title': title,
                'content': content,
              },
            ),
          )
          .then((response) => jsonDecode(response.body))
          .then((json) => ExternalNote.fromJson(json));

  @override
  Future<void> deleteNote(String id) =>
      _httpClient.delete(Uri.parse('$apiBaseUrl/notes/$id'));
}

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
