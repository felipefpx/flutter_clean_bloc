import 'package:flutter/material.dart';

import '../../../domain/models/note.dart';

class NoteListView extends StatelessWidget {
  const NoteListView({
    required this.notes,
    required this.onEditNote,
    required this.onDeleteNote,
    Key? key,
  }) : super(key: key);

  final Future<Object?>? Function(String) onEditNote;
  final void Function(String) onDeleteNote;
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
            onPressed: () => onDeleteNote(note.id),
          ),
          onTap: () => onEditNote(note.id),
        );
      },
      itemCount: notes.length,
    );
  }
}
