import 'package:flutter/material.dart';
import 'package:note_taking_app/models/note.dart';
import 'package:note_taking_app/providers/note_provider.dart';
import 'package:provider/provider.dart';

class NoteListItem extends StatelessWidget {
  final Note note;

  const NoteListItem({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    final NoteProvider noteProvider = Provider.of<NoteProvider>(context, listen: false);

    return Dismissible(
      key: Key(note.id), // Key là bắt buộc cho Dismissible
      direction: DismissDirection.horizontal,
      secondaryBackground: Container(
        color: cs.errorContainer, // Dùng màu từ theme
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Icon(
          Icons.delete,
          color: cs.onErrorContainer, // Dùng màu từ theme
        ),
      ),

      background: Container(
        color: cs.primaryContainer, // Dùng màu từ theme
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Icon(
          Icons.archive,
          color: cs.onPrimaryContainer, // Dùng màu từ theme
        ),
      ),
      
      onDismissed: (direction) {
        noteProvider.deleteNote(note.id);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Đã xóa ghi chú"),
            action: SnackBarAction(
              label: "Hoàn tác",
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Chức năng hoan tác chưa được triển khai"),
                    duration: Duration(seconds: 1),
                  )
                );
              },
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/editor',
              arguments: note, // Truyền object Note qua arguments
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title.isEmpty ? "Không có tiêu đề" : note.title,
                  style: tt.titleLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      noteProvider.formatDateTime(note.modifiedAt),
                      style: tt.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        noteProvider.getPlainText(note.content),
                        style: tt.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}