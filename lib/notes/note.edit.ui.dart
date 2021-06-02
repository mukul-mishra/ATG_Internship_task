import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:architecture/notes/note.bloc.dart';
import 'package:architecture/notes/note.event.dart';
import 'package:architecture/notes/note.model.dart';
import 'package:architecture/notes/note.state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotesEditUi extends StatefulWidget {
  final NoteModel n;
  NotesEditUi(this.n);
  @override
  _NotesEditUiState createState() => _NotesEditUiState();
}

class _NotesEditUiState extends State<NotesEditUi> {
  TextEditingController titleController;
  TextEditingController descriptionController;
  NoteBloc noteBloc;

  @override
  initState() {
    super.initState();
    titleController = TextEditingController()..text = widget.n.title;
    descriptionController = TextEditingController()
      ..text = widget.n.description;
  }

  void editNote() {
    noteBloc.add(EditNoteEvent(NoteModel(
        titleController.text, descriptionController.text, widget.n.time)));
  }

  @override
  Widget build(BuildContext context) {
    noteBloc = BlocProvider.of<NoteBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                hintText: "Enter title",
                alignLabelWithHint: true,
              ),
              controller: titleController,
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                hintText: "Enter description",
                alignLabelWithHint: true,
              ),
              controller: descriptionController,
            ),
            SizedBox(
              height: 16,
            ),
            BlocBuilder<NoteBloc, NoteState>(
                bloc: noteBloc,
                builder: (BuildContext context, NoteState state) {
                  if (state is AddingNoteInProgressState) {
                    return Center(child: CircularProgressIndicator());
                  } else
                    return RaisedButton(
                      onPressed: () {
                        editNote();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Update'),
                      ),
                    );
                }),
          ],
        ),
      ),
    );
  }
}
