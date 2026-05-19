import 'package:flutter/material.dart';
import 'package:notes_project/database/notes_database.dart';
import 'package:notes_project/screen/note_card.dart';
import 'package:notes_project/screen/note_dialog.dart';

const override = 'override';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Map<String, dynamic>> notes = [];

  final List<Color> notecolors = [
    // Colors.white,
    Colors.yellow.shade100,
    Colors.green.shade100,
    Colors.blue.shade100,
    Colors.pink.shade100,
    Colors.purple.shade100,
    Colors.orange.shade100,
    Colors.teal.shade100,
    Colors.grey.shade300,
    Colors.brown.shade200,
    Colors.cyan.shade100,
    Colors.lime.shade100,
    Colors.indigo.shade100,
    Colors.amber.shade100,
    Colors.deepOrange.shade100,
    Colors.red,
  ];

  @override
  void initState() {
    super.initState();
    fetchnotes();
  }

  Future<void> fetchnotes() async {
    final fetchnotes = await NotesDatabase.instance.getNotes();

    setState(() {
      notes = fetchnotes;
    });
  }

  void shownotedialog({
    int? noteId,
    String? title,
    String? content,
    int? colorindex = 0,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return NoteDialog(
          noteId: noteId,
          title: title,
          content: content,
          colorindex: colorindex,

          notecolors: [
            // Colors.white,
            Colors.yellow.shade100,
            Colors.green.shade100,
            Colors.blue.shade100,
            Colors.pink.shade100,
            Colors.purple.shade100,
            Colors.orange.shade100,
            Colors.teal.shade100,
            Colors.grey.shade300,
            Colors.brown.shade200,
            Colors.cyan.shade100,
            Colors.lime.shade100,
            Colors.indigo.shade100,
            Colors.amber.shade100,
            Colors.deepOrange.shade100,
            Colors.red,
          ],
          onnotesave:
              (
                newTitle,
                newDescription,
                currentDate, // Current date as string
                selectedcolorindex,
              ) async { 
                if (noteId == null) {
                  await NotesDatabase.instance.addnote(
                    newTitle,
                    newDescription,
                    currentDate, // Current date as string
                    selectedcolorindex,
                  );
                } else {
                  await NotesDatabase.instance.updateNote(
                    noteId,
                    newTitle,
                    newDescription,
                    currentDate, // Current date as string
                    selectedcolorindex,
                  );
                }

                fetchnotes();
              },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Notes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          shownotedialog();
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: notes.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notes_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'No notes available',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ],
              ),
            )
          : Padding(
              padding: EdgeInsets.all(20),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];

                  // colorindex ko int mein convert karna agar wo string ho
                  int colorindex = 0;
                  if (note['colorindex'] != null) {
                    if (note['colorindex'] is String) {
                      // Agar colorindex string ho to tryParse use karke usse int mein convert karo
                      colorindex = int.tryParse(note['colorindex']) ?? 0;
                    } else if (note['colorindex'] is int) {
                      // Agar colorindex already int ho to use directly
                      colorindex = note['colorindex'];
                    }
                  }

                  // Ensure that colorindex valid range mein ho (0 se leke notecolors ke length se kam ho)
                  colorindex = colorindex.clamp(0, notecolors.length - 1);

                  return NoteCard(
                    note: note,
                    ondelete: () async {
                      await NotesDatabase.instance.deleteNote(note["id"]);
                      fetchnotes();
                    },
                    ontap: () {
                      shownotedialog(
                        noteId: note['id'],
                        title: note['title'],
                        content: note['description'],
                        colorindex: note['color'],
                      );
                    },
                    notecolors: notecolors,
                  );
                },
              ),
            ),
    );
  }
}
