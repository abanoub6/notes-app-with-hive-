import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../controllers/notes_controller.dart';
import '../../widgets/note_card.dart';

class HiveNotesScreen extends StatefulWidget {
  const HiveNotesScreen({super.key});

  @override
  State<HiveNotesScreen> createState() => _HiveNotesScreenState();
}

class _HiveNotesScreenState extends State<HiveNotesScreen> {
  final controller = NotesController();

  void _showAddNoteSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller.titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller.contentController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "Content",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed:
                      () => setState(() {
                        controller.addNote(context);
                      }),
                  icon: const Icon(Icons.save),
                  label: const Text("Save Note"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.teal,
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notesBox = controller.notesBox;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hive Notes"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: ValueListenableBuilder(
        valueListenable: notesBox.listenable(),
        builder: (context, box, _) {
          final notes = box.values.toList();

          if (notes.isEmpty) {
            return const Center(
              child: Text(
                "No notes yet.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 3 / 4,
            ),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index] as Map;
              return NoteCard(
                title: note['title'],
                content: note['content'],
                onDelete:
                    () => setState(() {
                      controller.deleteNote(index);
                    }),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteSheet,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }
}
