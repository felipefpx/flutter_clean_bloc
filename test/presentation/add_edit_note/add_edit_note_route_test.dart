import 'package:flutter_clean_bloc/presentation/add_edit_note/add_edit_note_route.dart';
import 'package:flutter_clean_bloc/presentation/add_edit_note/add_edit_note_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../fakes.dart';
import '../../helpers.dart';
import '../mocks.dart';

void main() {
  late MockNotesUseCases mockUseCases;
  final note = fakeNote;

  setUp(() {
    mockUseCases = MockNotesUseCases();
    when(() => mockUseCases.getNote(any())).thenAnswer((_) async => note);
  });

  tearDown(() {
    reset(mockUseCases);
  });

  testWidgets(
    'When opened the route to add a note should display it',
    (tester) async {
      await launchRoutes(
        tester,
        addEditNoteRoutes,
        addNoteDeepLink(),
        mockUseCases,
      );

      expect(find.byType(AddEditNoteScreen), findsOneWidget);
      verifyNever(() => mockUseCases.getNote(note.id));
    },
  );

  testWidgets(
    'When opened the route to edit a note should display it',
    (tester) async {
      await launchRoutes(
        tester,
        addEditNoteRoutes,
        editNoteDeepLink(id: note.id),
        mockUseCases,
      );

      expect(find.byType(AddEditNoteScreen), findsOneWidget);
      verify(() => mockUseCases.getNote(note.id));
    },
  );
}
