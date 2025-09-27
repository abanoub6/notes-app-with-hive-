import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class NotesController {
  final Box notesBox = Hive.box('notesBox');

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  void addNote(BuildContext context) {
    if (titleController.text.isEmpty || contentController.text.isEmpty) return;

    notesBox.add({
      'title': titleController.text,
      'content': contentController.text,
    });

    titleController.clear();
    contentController.clear();
    Navigator.pop(context);
  }

  void deleteNote(int index) {
    notesBox.deleteAt(index);
  }
}
