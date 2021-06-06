import 'package:flutter_clean_bloc/domain/use_cases/notes_use_cases.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockNotesUseCases extends Mock implements NotesUseCases {}

class MockHttpClient extends Mock implements http.Client {}
