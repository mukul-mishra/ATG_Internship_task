import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:architecture/notes/note.bloc.dart';

import 'notes/note.add.ui.dart';
import 'notes/note.ui.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NoteBloc>(
            create: (context) => NoteBloc(), child: NotesUi()),
        BlocProvider<NoteBloc>(
            create: (context) => NoteBloc(), child: NotesAddUi()),
      ],
      child: MaterialApp(
        home: NotesUi(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
