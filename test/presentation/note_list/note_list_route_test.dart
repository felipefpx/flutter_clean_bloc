import 'package:flutter_clean_bloc/presentation/notes_list/note_list_route.dart';
import 'package:flutter_clean_bloc/presentation/notes_list/note_list_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../fakes.dart';
import '../../helpers.dart';
import '../mocks.dart';

void main() {
  late NoteListRoute route;
  late MockNotesUseCases mockUseCases;

  setUp(() {
    route = NoteListRoute();
    mockUseCases = MockNotesUseCases();

    when(() => mockUseCases.getNotes()).thenAnswer((_) async* {
      yield fakeNotes;
    });
  });

  tearDown(() {
    reset(mockUseCases);
  });

  testWidgets('When opened the route list should display it', (tester) async {
    await launchRoute(tester, route, mockUseCases);
    expect(find.byType(NotesListScreen), findsOneWidget);
  });
}
