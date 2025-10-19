import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:note_taking_app/models/note.dart';
import 'package:note_taking_app/providers/note_provider.dart';
import 'package:note_taking_app/screens/note_editor.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:note_taking_app/screens/search.dart';
import 'package:note_taking_app/widgets/drawer.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
  
}

class _HomeScreenState extends State<HomeScreen>{
  late ColorScheme cs;
  late TextTheme tt;
  
  @override
  Widget build(BuildContext context) {
    tt = Theme.of(context).textTheme;
    cs = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: AppDrawer(),
      appBar: _buildAppBar(),
      body: _buildNoteList(context, cs),
      floatingActionButton: _buildFAB()
    ); 
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      // toolbarOpacity: 1.0,

      // leading: IconButton(
      //   onPressed: () {
      //     Scaffold.of(context).openDrawer();
      //   }, 
      //   icon: Icon(Icons.menu, color: cs.onSurface)
      // ),
    
      title: Text(
        "Ghi chú",
      ),

      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
          }, 
          icon: Icon(Icons.search, color: cs.onSurface)
        ),
        SizedBox(
          width: 16,
        )
        // Padding(
        //   padding: const EdgeInsets.only(right: 8.0),
        //   child: IconButton(
        //     icon: const CircleAvatar(
        //       child: Text("U"),
        //     ),
        //     onPressed: () {
        //       // Điều hướng đến Màn hình Cài đặt (Settings Screen)
        //     },
        //   ),
        // ),
      ],
    );
  }

  Widget _buildNoteList(BuildContext context, ColorScheme cs) {
    final noteProvider = Provider.of<NoteProvider>(context);

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
      padding: const EdgeInsets.symmetric(horizontal: 16), 
      itemCount: noteProvider.notes.length,
      itemBuilder: (context, index) {
        final Note note = noteProvider.notes[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  NoteEditor(note: note)),
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
                        _formatDateTime(note.modifiedAt),
                        style: tt.bodyMedium?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _getPlainText(note.content),
                          style: tt.bodyMedium?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        );
      },
    );
  }

  FloatingActionButton _buildFAB() {
    return FloatingActionButton.extended(
      label: Text("Thêm ghi chú mới"),
      icon: Icon(Icons.add),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NoteEditor()),
        );

      }
    );
  }

  String _formatDateTime(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final noteDate = DateTime(dt.year, dt.month, dt.day);

    if (today == noteDate) {
      return DateFormat('HH:mm').format(dt);
    } else {
      return DateFormat('dd/MM/yyyy').format(dt);
    }
  }

  String _getPlainText(String jsonContent) {
    if (jsonContent.isEmpty) {
      return "Nội dung trống";
    }
    try {
      final decoded = jsonDecode(jsonContent) as List;
      final doc = Document.fromJson(decoded);
      return doc.toPlainText().trim().replaceAll('\n', ' ');
    } catch (e) {
      print("Lỗi parse nội dung note: $e");
      return "[Nội dung bị lỗi]";
    }
  }
}