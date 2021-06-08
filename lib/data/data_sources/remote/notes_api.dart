import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/external_note.dart';
import 'remote_notes_data_source.dart';

class NotesApi implements NotesRemoteDataSource {
  NotesApi({required http.Client httpClient}) : _httpClient = httpClient;

  static const apiBaseUrl = 'http://localhost:5000/api/v1';
  static const defaultHeaders = <String, String>{
    'content-type': 'application/json',
    'accept': 'application/json',
  };

  final http.Client _httpClient;

  @override
  Future<List<ExternalNote>> getNotes() => _httpClient
      .get(
        Uri.parse('$apiBaseUrl/notes'),
        headers: defaultHeaders,
      )
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
            headers: defaultHeaders,
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
      .get(
        Uri.parse('$apiBaseUrl/notes/$id'),
        headers: defaultHeaders,
      )
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
            headers: defaultHeaders,
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
  Future<void> deleteNote(String id) => _httpClient.delete(
        Uri.parse('$apiBaseUrl/notes/$id'),
        headers: defaultHeaders,
      );
}
