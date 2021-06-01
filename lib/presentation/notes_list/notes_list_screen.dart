import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app.dart';
import 'bloc/notes_list_bloc.dart';
import 'notes_list_strings.dart';

class NotesListScreen extends StatelessWidget {
  NotesListScreen({
    required this.onAddNewNote,
    required this.onEditNote,
  });

  final Future<Object?>? Function() onAddNewNote;
  final Future<Object?>? Function(String) onEditNote;

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotesListBloc, NotesListState>(
      listener: (context, state) {
        if (state is NotesListErrorState) {}
      },
      child: BlocBuilder<NotesListBloc, NotesListState>(
        builder: (context, state) => state.toWidget(
          context: context,
          onAddNewNote: onAddNewNote,
          onEditNote: onEditNote,
        ),
      ),
    );
  }
}

extension NotesListStateToWidget on NotesListState {
  Widget toWidget({
    required BuildContext context,
    required Future<Object?>? Function() onAddNewNote,
    required Future<Object?>? Function(String) onEditNote,
  }) {
    Widget body;

    if (this is NotesListLoadedState && notes.isEmpty) {
      body = Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            noteListEmptyMessage,
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else if (shimmering) {
      body = ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: SizedBox(
              child: Container(color: Colors.grey[400]),
              height: 16,
            ),
          );
        },
        itemCount: 3,
      );
    } else {
      body = ListView.builder(
        itemBuilder: (context, index) {
          final note = notes[index];
          return ListTile(
            title: Text(note.title),
            trailing: IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                context.read<NotesListBloc>().add(DeleteNoteEvent(note.id));
              },
            ),
            onTap: () async {
              final result = await onEditNote(note.id);
              if (result == true) {
                context.read<NotesListBloc>().add(const NotesListLoadEvent());
              }
            },
          );
        },
        itemCount: notes.length,
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
            context.read<NotesListBloc>().add(const NotesListLoadEvent());
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
