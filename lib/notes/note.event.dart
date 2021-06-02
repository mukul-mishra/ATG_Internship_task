import 'package:flutter/cupertino.dart';
import 'package:architecture/notes/note.model.dart';

class NoteEvent {}

///list of events
/// 1.getNotes 2.add 3.remove 4.remove 5.viewDetailNote

class GetNotesEvent extends NoteEvent {}

class GetTrashNotesEvent extends NoteEvent {}

class AddNoteEvent extends NoteEvent {
  NoteModel noteModel;

  AddNoteEvent(this.noteModel);
}

class EditNoteEvent extends NoteEvent {
  NoteModel noteModel;

  EditNoteEvent(this.noteModel);
}

class OpenAddNoteUiEvent extends NoteEvent {
  BuildContext context;
  OpenAddNoteUiEvent(this.context);
}

class OpenEditNoteUiEvent extends NoteEvent {
  BuildContext context;
  NoteModel note;
  OpenEditNoteUiEvent(this.context, this.note);
}

class RemoveNoteEvent extends NoteEvent {
  NoteModel m;

  RemoveNoteEvent(this.m);
}

class RemoveTrashNoteEvent extends NoteEvent {
  NoteModel m;

  RemoveTrashNoteEvent(this.m);
}

class UpdateNoteEvent extends NoteEvent {}

class ViewDetailNoteEvent extends NoteEvent {}
