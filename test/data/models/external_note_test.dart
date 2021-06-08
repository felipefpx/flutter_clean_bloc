import 'package:equatable/equatable.dart';
import 'package:flutter_clean_bloc/data/models/external_note.dart';
import 'package:flutter_clean_bloc/domain/models/note.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const id = 'n3E212A8F-5500-455D-B2C6-2163BA2321F4';
  const title = 'Test external note';
  const content = 'External note content';
  const externalNoteJson = <String, Object>{
    'id': id,
    'title': title,
    'content': content,
  };

  const externalNote = ExternalNote(
    id: id,
    title: title,
    content: content,
  );

  const note = Note(
    id: id,
    title: title,
    content: content,
  );

  setUp(() {
    EquatableConfig.stringify = true;
  });

  group('When parsing an external note', () {
    test('from json, assert correct instance', () {
      expect(ExternalNote.fromJson(externalNoteJson), externalNote);
    });

    test('to json, assert correct json', () {
      expect(externalNote.toJson(), externalNoteJson);
    });

    test('to note, assert correct note', () {
      expect(externalNote.toNote(), note);
    });

    test('to notes, assert correct notes', () {
      expect([externalNote].toNotes(), [note]);
    });
  });
}
