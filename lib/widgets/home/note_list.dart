import 'package:flutter/material.dart';
import 'package:note_taking_app/providers/note_provider.dart';
import 'package:note_taking_app/widgets/home/note_list_item.dart';
import 'package:provider/provider.dart';

class NoteList extends StatelessWidget {
  const NoteList({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    
    return Consumer<NoteProvider>(
      builder: (context, noteProvider, child) {
        if (noteProvider.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (noteProvider.notes.isEmpty) {
          // Trạng thái Rỗng
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lightbulb_outline, size: 64, color: cs.onSurfaceVariant),
                const SizedBox(height: 16),
                Text(
                  "Ghi chú của bạn trống",
                  style: TextStyle(fontSize: 18, color: cs.onSurfaceVariant),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: noteProvider.notes.length,
          itemBuilder: (context, index) => NoteListItem(note: noteProvider.notes[index]),
        );
      }
    );
  }
}