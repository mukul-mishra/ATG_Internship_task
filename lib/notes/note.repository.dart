import 'package:architecture/notes/note.model.dart';
import 'package:architecture/resources/firestore_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class NoteRepository {
  final _firestoreProvider = FirestoreProvider();

  Future<void> addNewNote(String title, String description, String time) =>
      _firestoreProvider.addNewNote(title, description, time);
  Future<void> addTrashNote(String title, String description, String time) =>
      _firestoreProvider.addNewTrashNote(title, description, time);

  Future<void> editNote(String title, String description, String time) =>
      _firestoreProvider.editNote(title, description, time);

  void removeNote(String t) {
    _firestoreProvider.removeNoat(t);
  }

  void removeTrashNote(String t) {
    _firestoreProvider.removeTrashNoat(t);
  }

  Stream<QuerySnapshot> getNotesList() => _firestoreProvider.NotesList();
}
