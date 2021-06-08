import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_bloc/app.dart';
import 'package:flutter_clean_bloc/domain/models/note.dart';
import 'package:flutter_clean_bloc/presentation/add_edit_note/bloc/add_edit_note_bloc.dart';
import 'package:flutter_clean_bloc/presentation/add_edit_note/add_edit_note_screen.dart';
import 'package:flutter_clean_bloc/presentation/add_edit_note/add_edit_note_strings.dart';
import 'package:flutter_test/flutter_test.dart';

class AddEditNoteScreenRobot {
  const AddEditNoteScreenRobot._();

  static Future<void> launch(
    WidgetTester tester, {
    required AddEditNoteBloc bloc,
    required VoidCallback onSaved,
    required VoidCallback onBack,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AddEditNoteBloc>(
          create: (context) => bloc,
          child: AddEditNoteScreen(
            onSaved: onSaved,
            onBack: onBack,
          ),
        ),
      ),
    );
    await tester.pump();
  }

  static void expectScreenVisible({Note? note, bool loading = false}) {
    expect(
      find.byType(CircularProgressIndicator),
      loading ? findsOneWidget : findsNothing,
    );

    expect(
      find.text(
        loading
            ? appName
            : note != null
                ? addEditNoteEditTitle
                : addEditNoteAddTitle,
      ),
      findsOneWidget,
    );

    if (!loading) {
      if (note != null) {
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is TextFormField &&
                widget.controller!.text == note.title,
          ),
          findsOneWidget,
        );
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is TextFormField &&
                widget.controller!.text == note.content,
          ),
          findsOneWidget,
        );
      } else {
        expect(
          find.text(addEditNoteTitleHint),
          findsOneWidget,
        );
        expect(
          find.text(addEditNoteContentHint),
          findsOneWidget,
        );
      }
    }
  }

  static void expectScreenErrorVisible() {
    expect(find.text(addEditNoteErrorTitle), findsOneWidget);
    expect(find.text(addEditNoteErrorMessage), findsOneWidget);
    expect(find.text(addEditNoteErrorAction), findsOneWidget);
  }

  static void expectInvalidInfoError({
    required bool invalidTitle,
    required bool invalidContent,
  }) {
    expect(
      find.text(addEditNoteInvalidTitle),
      invalidTitle ? findsOneWidget : findsNothing,
    );
    expect(
      find.text(addEditNoteInvalidContent),
      invalidContent ? findsOneWidget : findsNothing,
    );
  }

  static Future<void> typeTitle(WidgetTester tester, String title) async {
    await tester.enterText(find.text(addEditNoteTitleHint), title);
    await tester.pumpAndSettle();
  }

  static Future<void> typeContent(WidgetTester tester, String content) async {
    await tester.enterText(find.text(addEditNoteContentHint), content);
    await tester.pumpAndSettle();
  }

  static Future<void> tapOnBack(WidgetTester tester) async {
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
  }

  static Future<void> tapOnSave(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.save));
    await tester.pumpAndSettle();
  }

  static Future<void> tapOnCloseError(WidgetTester tester) async {
    await tester.tap(find.text(addEditNoteErrorAction));
    await tester.pumpAndSettle();
  }
}
