import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app.dart';
import '../shared/widgets/bottom_sheet.dart';
import '../shared/widgets/loading_view.dart';
import 'add_edit_note_strings.dart';
import 'bloc/add_edit_note_bloc.dart';

class AddEditNoteScreen extends StatefulWidget {
  const AddEditNoteScreen({
    required this.onSaved,
    required this.onBack,
  });

  final VoidCallback onSaved, onBack;

  @override
  State<StatefulWidget> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _titleTextController = TextEditingController();
  final _contentTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddEditNoteBloc, AddEditNoteState>(
      listener: (context, state) async {
        if (state is AddEditNoteSavedState) {
          widget.onSaved();
        }

        if (state is AddEditNoteErrorState) {
          await BottomSheetWidget.show(
            title: addEditNoteErrorTitle,
            message: addEditNoteErrorMessage,
            actionLabel: addEditNoteErrorAction,
            context: context,
          );
          widget.onBack();
        }
      },
      builder: (context, state) {
        if (state is AddEditNoteLoadedState && state.note != null) {
          _titleTextController.text = state.note!.title;
          _contentTextController.text = state.note!.content;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              state.loading
                  ? appName
                  : state.note != null
                      ? addEditNoteEditTitle
                      : addEditNoteAddTitle,
            ),
            centerTitle: true,
          ),
          body: state.loading
              ? LoadingView()
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
      },
    );
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _contentTextController.dispose();
    super.dispose();
  }
}
