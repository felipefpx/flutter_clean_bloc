import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app.dart';
import '../shared/widgets/app_bar_loading.dart';
import '../shared/widgets/bottom_sheet.dart';
import 'bloc/note_list_bloc.dart';
import 'note_list_strings.dart';
import 'views/note_list_empty_view.dart';
import 'views/note_list_shimmering_view.dart';
import 'views/note_list_view.dart';

class NoteListScreen extends StatelessWidget {
  const NoteListScreen({
    required this.onAddNewNote,
    required this.onEditNote,
    required this.onBack,
    Key? key,
  }) : super(key: key);

  final VoidCallback onBack;
  final Future<Object?>? Function() onAddNewNote;
  final Future<Object?>? Function(String) onEditNote;

  @override
  Widget build(BuildContext context) {
    context.read<NoteListBloc>();
    return BlocConsumer<NoteListBloc, NoteListState>(
      listener: (context, state) async {
        if (state is NoteListErrorState) {
          await BottomSheetWidget.show(
            title: noteListErrorTitle,
            message: noteListErrorMessage,
            actionLabel: noteListErrorAction,
            context: context,
          );
          onBack();
        }
      },
      builder: (context, state) => state.toWidget(
        context: context,
        onAddNewNote: onAddNewNote,
        onDeleteNote: (noteId) {
          context.read<NoteListBloc>().add(DeleteNoteEvent(noteId));
        },
        onEditNote: (noteId) async {
          final result = await onEditNote(noteId);
          if (result == true) {
            context.read<NoteListBloc>().add(const NoteListLoadEvent());
          }
        },
      ),
    );
  }
}

extension NotesListStateToWidget on NoteListState {
  Widget toWidget({
    required BuildContext context,
    required Future<Object?>? Function() onAddNewNote,
    required Future<Object?>? Function(String) onEditNote,
    required void Function(String) onDeleteNote,
  }) {
    Widget body;

    if (this is NoteListLoadedState && notes.isEmpty) {
      body = NoteListEmptyView();
    } else if (shimmering) {
      body = NoteListShimmeringView();
    } else {
      body = NoteListView(
        notes: notes,
        onEditNote: onEditNote,
        onDeleteNote: onDeleteNote,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
        centerTitle: true,
        actions: [
          Visibility(
            child: const AppBarLoading(),
            visible: loading,
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SafeArea(child: body),
      floatingActionButton: FloatingActionButton(
        key: const Key('add_note'),
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await onAddNewNote();
          if (result == true) {
            context.read<NoteListBloc>().add(const NoteListLoadEvent());
          }
        },
      ),
    );
  }
}
