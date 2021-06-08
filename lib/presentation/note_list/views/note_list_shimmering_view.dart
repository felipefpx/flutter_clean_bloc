import 'package:flutter/material.dart';

class NoteListShimmeringView extends StatelessWidget {
  const NoteListShimmeringView();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
  }
}
