import 'package:flutter/material.dart';

import '../note_list_strings.dart';

class NoteListEmptyView extends StatelessWidget {
  const NoteListEmptyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          noteListEmptyMessage,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
