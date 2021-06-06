import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app.dart';
import '../shared/widgets/bottom_sheet.dart';
import 'bloc/note_list_bloc.dart';
import 'note_list_strings.dart';
import 'views/note_list_empty_view.dart';
import 'views/note_list_shimmering_view.dart';
import 'views/note_list_view.dart';

class NotesListScreen extends StatelessWidget {
  const NotesListScreen({
    required this.onAddNewNote,
    required this.onEditNote,
    required this.onBack,
  });

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
        onEditNote: onEditNote,
      ),
    );
  }
}

extension NotesListStateToWidget on NoteListState {
  Widget toWidget({
    required BuildContext context,
    required Future<Object?>? Function() onAddNewNote,
    required Future<Object?>? Function(String) onEditNote,
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
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
        centerTitle: true,
        actions: [
          Visibility(
            child: Center(
              child: SizedBox(
                child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
                height: 20.0,
                width: 20.0,
              ),
            ),
            visible: loading,
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SafeArea(child: body),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await onAddNewNote();
          if (result == true) {
            context.read<NoteListBloc>().add(const NoteListLoadEvent());
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
