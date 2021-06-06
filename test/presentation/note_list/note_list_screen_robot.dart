import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_bloc/app.dart';
import 'package:flutter_clean_bloc/domain/models/note.dart';
import 'package:flutter_clean_bloc/presentation/note_list/bloc/note_list_bloc.dart';
import 'package:flutter_clean_bloc/presentation/note_list/note_list_screen.dart';
import 'package:flutter_clean_bloc/presentation/note_list/note_list_strings.dart';
import 'package:flutter_clean_bloc/presentation/note_list/views/note_list_empty_view.dart';
import 'package:flutter_clean_bloc/presentation/note_list/views/note_list_shimmering_view.dart';
import 'package:flutter_clean_bloc/presentation/shared/widgets/app_bar_loading.dart';
import 'package:flutter_test/flutter_test.dart';

class NoteListScreenRobot {
  const NoteListScreenRobot._();

  static Future<void> launch(
    WidgetTester tester, {
    required NoteListBloc bloc,
    required Future<Object?> Function() onAddNewNote,
    required Future<Object?> Function(String) onEditNote,
    required VoidCallback onBack,
    bool awaitSettled = false,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<NoteListBloc>(
          create: (context) => bloc,
          child: NoteListScreen(
            onAddNewNote: onAddNewNote,
            onEditNote: onEditNote,
            onBack: onBack,
          ),
        ),
      ),
    );
    if (!awaitSettled) {
      await tester.pump();
    } else {
      await tester.pumpAndSettle();
    }
  }

  static void expectScreenVisible({
    List<Note> notes = const [],
    bool loading = false,
    bool shimmering = false,
  }) {
    expect(
      find.byType(AppBarLoading),
      loading ? findsOneWidget : findsNothing,
    );

    expect(
      find.text(appName),
      findsOneWidget,
    );

    expect(
      find.byType(NoteListShimmeringView),
      shimmering ? findsOneWidget : findsNothing,
    );

    if (!shimmering) {
      if (notes.isEmpty) {
        expect(find.byType(NoteListEmptyView), findsOneWidget);
      } else {
        for (var note in notes) {
          expect(
            _findNoteTile(note),
            findsOneWidget,
          );
        }
      }
    }
  }

  static void expectScreenErrorVisible() {
    expect(find.text(noteListErrorTitle), findsOneWidget);
    expect(find.text(noteListErrorMessage), findsOneWidget);
    expect(find.text(noteListErrorAction), findsOneWidget);
  }

  static Future<void> tapOnBack(WidgetTester tester) async {
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
  }

  static Future<void> tapOnDelete(WidgetTester tester, Note note) async {
    await tester.tap(
      find.descendant(
        of: _findNoteTile(note),
        matching: find.byIcon(Icons.delete),
      ),
    );
    await tester.pumpAndSettle();
  }

  static Future<void> tapOnAdd(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
  }

  static Future<void> tapOnEdit(WidgetTester tester, Note note) async {
    await tester.tap(_findNoteTile(note));
    await tester.pumpAndSettle();
  }

  static Future<void> tapOnCloseError(WidgetTester tester) async {
    await tester.tap(find.text(noteListErrorAction));
    await tester.pumpAndSettle();
  }

  static Finder _findNoteTile(Note note) => find.byWidgetPredicate(
        (widget) =>
            widget is ListTile &&
            ((widget.trailing as IconButton).icon as Icon).icon ==
                Icons.delete &&
            (widget.title as Text).data == note.title,
      );
}
