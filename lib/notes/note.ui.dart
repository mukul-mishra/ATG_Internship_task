import 'package:architecture/notes/note.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:architecture/notes/note.bloc.dart';
import 'package:architecture/notes/note.event.dart';
import 'package:architecture/notes/note.state.dart';
import 'package:architecture/notes/note.storage.dart';

class NotesUi extends StatefulWidget {
  @override
  _NotesUiState createState() => _NotesUiState();
}

class _NotesUiState extends State<NotesUi> {
  @override
  Widget build(BuildContext context) {
    final NoteBloc noteBloc = BlocProvider.of<NoteBloc>(context);
    //final NoteStorage a = NoteStorage();
    List<NoteModel> a = [];
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              noteBloc.add(OpenAddNoteUiEvent(context));
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: BlocBuilder<NoteBloc, NoteState>(
          bloc: noteBloc,
          builder: (BuildContext context, NoteState state) {
            if (state is InitialNoteState) {
              return Center(
                child: Text('Welcome to notes app'),
              );
            } else if (state is FetchingNoteCompleteState) {
              return StreamBuilder(
                stream: Firestore.instance.collection("Notes").snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  List<NoteModel> e = [];
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.blue,
                      ),
                    );
                  }
                  final doc = snapshot.data.documents;
                  for (int i = 0; i < doc.length; i++) {
                    e.add(new NoteModel(doc[i]["title"], doc[i]["description"],
                        doc[i]["time"]));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: e.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: Column(
                          children: [
                            InkWell(
                              child: ListTile(
                                title: Text(e[index].title),
                                subtitle: Text(e[index].description),
                              ),
                              onTap: () {
                                noteBloc.add(
                                    OpenEditNoteUiEvent(context, e[index]));
                              },
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  noteBloc.add(RemoveNoteEvent(e[index]));
                                  //noteBloc.add(GetNotesEvent());
                                  print(e[index].time);
                                },
                                child: Text("remove"))
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            } else if (state is FetchingTrashNoteCompleteState) {
              return StreamBuilder(
                stream:
                    Firestore.instance.collection("Trash_Notes").snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  List<NoteModel> d = [];
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.blue,
                      ),
                    );
                  }
                  final doc = snapshot.data.documents;
                  for (int i = 0; i < doc.length; i++) {
                    d.add(new NoteModel(doc[i]["title"], doc[i]["description"],
                        doc[i]["time"]));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: d.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: Column(
                          children: [
                            InkWell(
                              child: ListTile(
                                title: Text(d[index].title),
                                subtitle: Text(d[index].description),
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  noteBloc.add(AddNoteEvent(d[index]));
                                  noteBloc.add(RemoveTrashNoteEvent(d[index]));
                                },
                                child: Text("restore"))
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              return Text("No Notes");
            }
          }),
      bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            FloatingActionButton(
                backgroundColor: Colors.blue,
                //label: "Notes",
                child: Icon(Icons.note),
                onPressed: () {
                  noteBloc.add(GetNotesEvent());
                }),
            FloatingActionButton(
                backgroundColor: Colors.red,
                //label: "Notes",
                child: Icon(Icons.note),
                onPressed: () {
                  noteBloc.add(GetTrashNotesEvent());
                })
          ])),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_comment),
        onPressed: () {
          noteBloc.add(OpenAddNoteUiEvent(context));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
