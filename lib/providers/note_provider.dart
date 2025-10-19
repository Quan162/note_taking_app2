import 'package:flutter/material.dart';
import 'package:note_taking_app/models/note.dart';

class NoteProvider extends ChangeNotifier {
  final List<Note> _notes = [];

  List<Note> get notes => [..._notes];

  String addNote(String title, String content) {
    final idNote = DateTime.now().millisecondsSinceEpoch.toString();
    final newNote = Note(
      id: idNote,
      title: title.trim(),
      content: content.trim(),
      modifiedAt: DateTime.now()
    );

    _notes.add(newNote);
    notifyListeners();
    return idNote;
  }

  void deleteNote(String id) {
    _notes.removeWhere((note) => note.id == id);
    notifyListeners(); 
  }

  void updateNote(String id, String newTitle, String newContent) {
      // Tìm vị trí (index) của ghi chú cũ
      final index = _notes.indexWhere((note) => note.id == id);

      if (index != -1) {
        final updatedNote = Note(
          id: id,
          title: newTitle,
          content: newContent,
          modifiedAt: DateTime.now()
        );
        
        _notes[index] = updatedNote;
        notifyListeners();
      }
    }

  List<Note> searchNotes(String query) {
    if (query.isEmpty) {
      return []; // Không tìm kiếm nếu query rỗng
    }

    final lowerCaseQuery = query.toLowerCase();
    
    return _notes.where((note) {
      final titleLower = note.title.toLowerCase();
      final contentLower = note.content.toLowerCase();
      
      return titleLower.contains(lowerCaseQuery) ||
             contentLower.contains(lowerCaseQuery);
    }).toList();
  }
}