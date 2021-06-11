import 'package:faker/faker.dart';
import 'package:flutter_clean_bloc/data/models/external_note.dart';
import 'package:flutter_clean_bloc/domain/models/note.dart';
import 'package:http/http.dart' as http;

const _alphaNumericCharSet =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

Faker get faker => Faker();

Note get fakeNote => Note(
      id: faker.randomGenerator.fromCharSet(_alphaNumericCharSet, 5),
      title: faker.lorem.sentence(),
      content: faker.lorem.sentence(),
    );

ExternalNote get fakeExternalNote => ExternalNote(
      id: faker.randomGenerator.fromCharSet(_alphaNumericCharSet, 5),
      title: faker.lorem.sentence(),
      content: faker.lorem.sentence(),
    );

List<Note> get fakeNotes => [fakeNote, fakeNote, fakeNote];

List<ExternalNote> get fakeExternalNotes =>
    [fakeExternalNote, fakeExternalNote, fakeExternalNote];

http.Response fakeResponse(String body, int code) => http.Response(body, code);
