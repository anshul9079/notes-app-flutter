import 'package:flutter/material.dart';
import 'package:notes_project/screen/notes_screen.dart';

class NoteCard extends StatelessWidget {
  final Map<String, dynamic> note;
  final Function ondelete;
  final Function ontap;
  final List<Color> notecolors;

  const NoteCard({
    super.key,
    required this.note,
    required this.ondelete,
    required this.ontap,
    required this.notecolors,
  });

  @override
  Widget build(BuildContext context) {
    // Safe handling of colorindex (default to 0 if null)
    int colorindex = note['color'] ?? 0;
    colorindex = colorindex.clamp(
      0,
      notecolors.length - 1,
    ); // Ensure valid index

    return GestureDetector(
      onTap: () => ontap(), // Trigger on tap

      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notecolors[colorindex], // Apply selected color
          borderRadius: BorderRadius.circular(20),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Safe handling of 'date' (fallback to 'No Date' if null)
            Text(
              note['date'] ?? 'No Date', // Fallback if 'date' is null
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            SizedBox(height: 8),

            // Safe handling of 'title' (fallback to 'No Title' if null)
            Text(
              note['title'] ?? 'No Title', // Fallback if 'title' is null
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
                color: Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 3),

            // Safe handling of 'content' (fallback to 'No Content' if null)
            Expanded(
              child: Text(
                note['description'] ??
                    'No content', // Fallback if 'content' is null
                style: TextStyle(height: 1.4, color: Colors.black54),
                overflow: TextOverflow.fade,
              ),
            ),

            // Delete Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.black54,
                    size: 23,
                  ),
                  onPressed: () => ondelete(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
