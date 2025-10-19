// file: search_page.dart

import 'package:flutter/material.dart';
import 'package:note_taking_app/models/note.dart';
import 'package:note_taking_app/providers/note_provider.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  List<Note> _searchResults = [];

  void _performSearch(String query) {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    
    setState(() {
      _searchResults = noteProvider.searchNotes(query);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true, 
          decoration: const InputDecoration(
            hintText: 'Tìm kiếm tiêu đề hoặc nội dung...',
            border: InputBorder.none,
          ),
          onChanged: _performSearch,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              _performSearch('');
            },
          )
        ],
      ),
      body: _searchResults.isEmpty
          ? Center(
              child: Text(
                _searchController.text.isEmpty
                    ? 'Gõ để bắt đầu tìm kiếm'
                    : 'Không tìm thấy kết quả nào',
              ),
            )
          : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final note = _searchResults[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(note.content),
                );
              },
            ),
    );
  }
}