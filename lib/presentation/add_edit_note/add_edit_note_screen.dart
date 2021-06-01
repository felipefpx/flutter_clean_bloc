import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app.dart';
import 'add_edit_note_strings.dart';
import 'bloc/add_edit_note_bloc.dart';

class AddEditNoteScreen extends StatefulWidget {
  const AddEditNoteScreen({required this.onSaved});

  final VoidCallback onSaved;

  @override
  State<StatefulWidget> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _titleTextController = TextEditingController();
  final _contentTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddEditNoteBloc, AddEditNoteState>(
      listener: (context, state) {
        if (state is AddEditNoteSavedState) {
          widget.onSaved();
        }
      },
      child: BlocBuilder<AddEditNoteBloc, AddEditNoteState>(
          builder: (context, state) {
        if (state is AddEditNoteLoadedState && state.note != null) {
          _titleTextController.text = state.note!.title;
          _contentTextController.text = state.note!.content;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              state is AddEditNoteLoadingState
                  ? appName
                  : state.note != null
                      ? addEditNoteEditTitle
                      : addEditNoteAddTitle,
            ),
          ),
          body: state is AddEditNoteLoadingState
              ? Center(
                  child: SizedBox(
                    height: 48,
                    width: 48,
                    child: CircularProgressIndicator(),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleTextController,
                        decoration: InputDecoration(
                          hintText: addEditNoteTitleHint,
                          errorText: state is AddEditNoteInvalidInfoState &&
                                  state.invalidTitle
                              ? addEditNoteInvalidTitle
                              : null,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _contentTextController,
                        minLines: 3,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: addEditNoteContentHint,
                          errorText: state is AddEditNoteInvalidInfoState &&
                                  state.invalidContent
                              ? addEditNoteInvalidContent
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
          floatingActionButton: state is AddEditNoteLoadingState
              ? null
              : FloatingActionButton(
                  child: Icon(Icons.save),
                  onPressed: () {
                    context.read<AddEditNoteBloc>().add(AddEditNoteSubmitEvent(
                          id: state.note?.id,
                          title: _titleTextController.text,
                          content: _contentTextController.text,
                        ));
                  },
                ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _contentTextController.dispose();
    super.dispose();
  }
}