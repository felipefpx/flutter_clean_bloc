import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/external_note.dart';
import 'remote_notes_data_source.dart';

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
