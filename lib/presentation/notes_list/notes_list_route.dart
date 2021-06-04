import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuvigator/next.dart';

import '../add_edit_note/add_edit_note_route.dart';
import '../shared/route_helper.dart';
import 'bloc/notes_list_bloc.dart';
import 'notes_list_screen.dart';

const _notesListPath = 'notes';

String notesListDeepLink({bool includeSchema = false}) =>
    appDeepLink(_notesListPath, includeSchema: includeSchema);

class NotesListRoute extends NuRoute {
  @override
  Widget build(BuildContext context, NuRouteSettings<Object> settings) {
    return BlocProvider<NotesListBloc>(
      create: (context) => NotesListBloc(notesUseCases: context.read())
        ..add(const NotesListLoadEvent()),
      child: NotesListScreen(
        onClose: () => exit(0),
        onAddNewNote: () =>
            Nuvigator.of(context)?.open(addNoteDeepLink(includeSchema: true)),
        onEditNote: (id) => Nuvigator.of(context)
            ?.open(editNoteDeepLink(id: id, includeSchema: true)),
      ),
    );
  }

  @override
  String get path => notesListDeepLink();

  @override
  ScreenType? get screenType => MaterialScreenType();
}
