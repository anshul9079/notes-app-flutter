import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const override = 'override';

class NoteDialog extends StatefulWidget {
  final int? noteId;
  final String? title;
  final String? content;
  final int? colorindex;
  final List<Color> notecolors;
  final Function onnotesave;

  const NoteDialog({
    super.key,
    this.noteId,
    this.title,
    this.content,
    required this.colorindex,
    required this.notecolors,
    required this.onnotesave,
  });

  @override
  _NoteDialogState createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  late int selectedcolorindex;

  @override
  void initState() {
    super.initState();
    selectedcolorindex = widget.colorindex ?? 0; // Default to 0 if null
  }

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: widget.title);
    final descriptionController = TextEditingController(text: widget.content);
    final currentDate = DateFormat('dd-MM-yyyy ').format(DateTime.now());

    return AlertDialog(
      backgroundColor: widget.notecolors[selectedcolorindex],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        widget.noteId == null ? "Add Note" : "Edit Note",
        style: TextStyle(color: Colors.black87),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentDate,
              style: TextStyle(color: Colors.black87, fontSize: 14),
            ),
            SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.6),
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: List.generate(
                widget.notecolors.length,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedcolorindex = index;
                    });
                  },
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: widget.notecolors[index],
                    child: selectedcolorindex == index
                        ? Icon(Icons.check, color: Colors.black, size: 16)
                        : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },

          child: Text("Cancel", style: TextStyle(color: Colors.black54)),
        ),
        ElevatedButton(
          onPressed: () {
            final newTitle = titleController.text;
            final newDescription = descriptionController.text;

            widget.onnotesave(
              newTitle,
              newDescription,
              currentDate, // Current date as string
              selectedcolorindex, // Selected color index
            );
            Navigator.pop(context); // Close the dialog
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text("Save", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
