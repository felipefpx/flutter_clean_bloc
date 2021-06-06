import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/note.dart';
import '../bloc/note_list_bloc.dart';

class NoteListView extends StatelessWidget {
  const NoteListView({
    required this.notes,
    required this.onEditNote,
  });

  final Future<Object?>? Function(String) onEditNote;
  final List<Note> notes;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
              context.read<NoteListBloc>().add(DeleteNoteEvent(note.id));
            },
          ),
          onTap: () async {
            final result = await onEditNote(note.id);
            if (result == true) {
              context.read<NoteListBloc>().add(const NoteListLoadEvent());
            }
          },
        );
      },
      itemCount: notes.length,
    );
  }
}
