import 'dart:convert';

import 'package:flutter_clean_bloc/data/data_sources/remote/notes_api.dart';
import 'package:flutter_clean_bloc/data/data_sources/remote/remote_notes_data_source.dart';
import 'package:flutter_clean_bloc/data/models/external_note.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../../fakes.dart';
import '../../../presentation/mocks.dart';

void main() {
  late NotesRemoteDataSource notesRemoteDs;
  late http.Client httpClient;

  const id = 'n3E212A8F-5500-455D-B2C6-2163BA2321F4';
  const title = 'Test external note';
  const content = 'External note content';
  const externalNoteJson = '{'
      '"id": "$id",'
      '"title": "$title",'
      '"content": "$content"'
      '}';

  const externalNote = ExternalNote(
    id: id,
    title: title,
    content: content,
  );

  group('When using notes api', () {
    setUp(() {
      httpClient = MockHttpClient();
      notesRemoteDs = NotesApi(httpClient: httpClient);
    });

    tearDown(() {
      reset(httpClient);
    });

    test('to get the notes, assert success', () async {
      when(() => httpClient.get(Uri.parse('${NotesApi.apiBaseUrl}/notes')))
          .thenAnswer((_) async => fakeResponse('[$externalNoteJson]', 200));

      final result = await notesRemoteDs.getNotes();
      expect(result, [externalNote]);
    });

    test('to getting a note, assert success', () async {
      when(() => httpClient.get(Uri.parse('${NotesApi.apiBaseUrl}/notes/$id')))
          .thenAnswer((_) async => fakeResponse(externalNoteJson, 200));

      final result = await notesRemoteDs.getNote(id);
      expect(result, externalNote);
    });

    test('to creating a note, assert success', () async {
      when(
        () => httpClient.post(
          Uri.parse('${NotesApi.apiBaseUrl}/notes'),
          body: jsonEncode({
            'title': title,
            'content': content,
          }),
        ),
      ).thenAnswer((_) async => fakeResponse(externalNoteJson, 200));

      final result = await notesRemoteDs.postNote(
        title: title,
        content: content,
      );
      expect(result, externalNote);
    });

    test('to updating a note, assert success', () async {
      when(
        () => httpClient.put(
          Uri.parse('${NotesApi.apiBaseUrl}/notes/$id'),
          body: jsonEncode({
            'title': title,
            'content': content,
          }),
        ),
      ).thenAnswer((_) async => fakeResponse(externalNoteJson, 200));

      final result = await notesRemoteDs.putNote(
        id: id,
        title: title,
        content: content,
      );
      expect(result, externalNote);
    });

    test('to deleting a note, assert success', () async {
      when(
        () => httpClient.delete(
          Uri.parse('${NotesApi.apiBaseUrl}/notes/$id'),
        ),
      ).thenAnswer((_) async => fakeResponse(externalNoteJson, 200));

      await notesRemoteDs.deleteNote(id);
      verify(() =>
          httpClient.delete(Uri.parse('${NotesApi.apiBaseUrl}/notes/$id')));
    });
  });
}
