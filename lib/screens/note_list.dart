import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:note_taking_app/models/note.dart';
import 'package:note_taking_app/providers/note_provider.dart';
import 'package:note_taking_app/screens/note_editor_rich.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:note_taking_app/screens/search.dart';
import 'package:note_taking_app/widgets/drawer.dart';
import 'package:note_taking_app/widgets/home/note_list.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _NoteListScreenState();
  
}

class _NoteListScreenState extends State<NoteListScreen>{
  late ColorScheme cs;
  late TextTheme tt;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // listen: false là bắt buộc khi gọi troFng initState
      Provider.of<NoteProvider>(context, listen: false).loadNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    tt = Theme.of(context).textTheme;
    cs = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: AppDrawer(),
      appBar: _buildAppBar(),
      body: const NoteList(),
      floatingActionButton: _buildFAB()
    ); 
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
    
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
      ],
    );
  }

  FloatingActionButton _buildFAB() {
    return FloatingActionButton.extended(
      label: Text("Thêm ghi chú mới"),
      icon: Icon(Icons.add),
      onPressed: () {
        Navigator.pushNamed(
          context,
          '/editor',
        );
      }
    );
  }

}