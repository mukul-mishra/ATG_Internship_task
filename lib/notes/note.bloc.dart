import 'package:architecture/notes/note.edit.ui.dart';
import 'package:architecture/notes/note.repository.dart';
import 'package:architecture/notes/note.storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:architecture/notes/note.event.dart';
import 'package:architecture/notes/note.model.dart';
import 'package:architecture/notes/note.state.dart';
//import 'package:architecture/notes/note.storage.dart';

import 'note.add.ui.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final _repository = NoteRepository();
  NoteBloc() : super(InitialNoteState());
  Stream<QuerySnapshot> notes() {
    return _repository.getNotesList();
  }

  @override
  Stream<NoteState> mapEventToState(NoteEvent event) async* {
    if (event is GetNotesEvent) {
      yield FetchingNoteCompleteState();
    } else if (event is GetTrashNotesEvent) {
      yield FetchingTrashNoteCompleteState();
    } else if (event is OpenAddNoteUiEvent) {
      Navigator.push(
          event.context, MaterialPageRoute(builder: (context) => NotesAddUi()));
    } else if (event is AddNoteEvent) {
      yield AddingNoteInProgressState();
      _repository.addNewNote(event.noteModel.title, event.noteModel.description,
          event.noteModel.time);
      yield FetchingNoteCompleteState();
    } else if (event is RemoveNoteEvent) {
      yield AddingNoteInProgressState();
      _repository.removeNote(event.m.time);
      _repository.addTrashNote(
          event.m.title, event.m.description, event.m.time);
      yield FetchingNoteCompleteState();
    } else if (event is RemoveTrashNoteEvent) {
      yield AddingNoteInProgressState();
      _repository.removeTrashNote(event.m.time);
      yield FetchingTrashNoteCompleteState();
    } else if (event is OpenEditNoteUiEvent) {
      Navigator.push(event.context,
          MaterialPageRoute(builder: (context) => NotesEditUi(event.note)));
    } else if (event is EditNoteEvent) {
      _repository.editNote(event.noteModel.title, event.noteModel.description,
          event.noteModel.time);
      yield FetchingNoteCompleteState();
    }
  }
}
