import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuvigator/next.dart';

import '../add_edit_note/add_edit_note_route.dart';
import '../shared/route_helper.dart';
import 'bloc/note_list_bloc.dart';
import 'note_list_screen.dart';

const _noteListPath = 'notes';

String noteListDeepLink({bool includeSchema = false}) =>
    appDeepLink(_noteListPath, includeSchema: includeSchema);

class NoteListRoute extends NuRoute {
  @override
  Widget build(BuildContext context, NuRouteSettings<Object> settings) {
    return BlocProvider<NoteListBloc>(
      create: (context) => NoteListBloc(notesUseCases: context.read())
        ..add(const NoteListLoadEvent()),
      child: NoteListScreen(
        onBack: () => exit(0),
        onAddNewNote: () =>
            Nuvigator.of(context)?.open(addNoteDeepLink(includeSchema: true)),
        onEditNote: (id) => Nuvigator.of(context)
            ?.open(editNoteDeepLink(id: id, includeSchema: true)),
      ),
    );
  }

  @override
  String get path => noteListDeepLink();

  @override
  ScreenType? get screenType => MaterialScreenType();
}
