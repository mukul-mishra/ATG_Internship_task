import 'package:architecture/notes/note.storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:architecture/notes/note.model.dart';

class FirestoreProvider {
  Firestore _firestore = Firestore.instance;

  Future<void> addNewNote(String title, String description, String time) async {
    return _firestore
        .collection("Notes")
        .document(time)
        .setData({"title": title, "description": description, "time": time});
  }

  Future<void> addNewTrashNote(
      String title, String description, String time) async {
    return _firestore
        .collection("Trash_Notes")
        .document(time)
        .setData({"title": title, "description": description, "time": time});
  }

  Future<void> editNote(String title, String description, String time) async {
    return _firestore
        .collection("Notes")
        .document(time)
        .updateData({"title": title, "description": description});
  }

  Stream<QuerySnapshot> NotesList() {
    return _firestore.collection("Notes").snapshots();
  }

  Stream<DocumentSnapshot> TrashlList() {
    return _firestore.collection("Trash").document().snapshots();
  }

  Future<void> removeNoat(String time) async {
    return _firestore.collection("Notes").document(time).delete();
  }

  Future<void> removeTrashNoat(String time) async {
    return _firestore.collection("Trash_Notes").document(time).delete();
  }

  void getNotes(List<NoteModel> c) async {
    c.clear();
    await Firestore.instance
        .collection("Notes")
        .getDocuments()
        .then((QuerySnapshot snapShot) {
      for (int i = 0; i < snapShot.documents.length; i++) {
        c.add(new NoteModel(
            snapShot.documents[i]["title"],
            snapShot.documents[i]["description"],
            snapShot.documents[i]["time"]));
      }
    });
  }
}
