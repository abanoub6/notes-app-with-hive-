import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveNotesScreen extends StatefulWidget {
  const HiveNotesScreen({super.key});

  @override
  State<HiveNotesScreen> createState() => _HiveNotesScreenState();
}

class _HiveNotesScreenState extends State<HiveNotesScreen> {
  final notesBox = Hive.box('notesBox');

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  void _addNote() {
    if (titleController.text.isEmpty || contentController.text.isEmpty) return;

    notesBox.add({
      'title': titleController.text,
      'content': contentController.text,
    });

    titleController.clear();
    contentController.clear();
    Navigator.pop(context);
  }

  void _deleteNote(int index) {
    notesBox.deleteAt(index);
  }

  void _showAddNoteSheet() {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(labelText: "Content"),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addNote,
                  child: const Text("Save Note"),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hive Notes")),
      body: ValueListenableBuilder(
        valueListenable: notesBox.listenable(),
        builder: (context, box, _) {
          final notes = box.values.toList();

          if (notes.isEmpty) {
            return const Center(child: Text("No notes yet."));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // شكل Grid 2 أعمدة
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index] as Map;
              return Card(
                color: Colors.teal[50],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Positioned(
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteNote(index),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(note['content']),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteSheet,
        child: const Icon(Icons.add),
      ),
    );
  }
}
