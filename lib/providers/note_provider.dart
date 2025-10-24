import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:note_taking_app/models/note.dart';
import 'package:note_taking_app/repositories/note_repository.dart';

class NoteProvider extends ChangeNotifier {
  final NoteRepository _noteRepository = NoteRepository();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Note> _notes = [];
  List<Note> get notes => [..._notes];

  Future<void> loadNotes() async {
    _isLoading = true;
    notifyListeners();
    
    _notes = await _noteRepository.getAllNotes();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<String> addNote(String title, String content) async{
    final idNote = Uuid().v4();
    final newNote = Note(
      id: idNote,
      title: title.trim(),
      content: content.trim(),
      modifiedAt: DateTime.now(),
      createdAt: DateTime.now()
    );

    await _noteRepository.saveNote(newNote); 

    _notes.insert(0, newNote);
    notifyListeners();
    return idNote;
  }

  Future<void> deleteNote(String id) async{
    await _noteRepository.deleteNote(id);

    _notes.removeWhere((note) => note.id == id);
    notifyListeners(); 
  }

  Future<void> updateNote(String id, String newTitle, String newContent) async {
    final index = _notes.indexWhere((note) => note.id == id);
      
    if (index != -1) {
      final originalNote = _notes[index];
      
      final updatedNote = originalNote.copyWith(
        title: newTitle.trim().isEmpty ? 'Untitled' : newTitle.trim(),
        content: newContent.trim(),
        modifiedAt: DateTime.now(),
      );
      
      await _noteRepository.saveNote(updatedNote);

      _notes.removeAt(index);
      _notes.insert(0, updatedNote);
      
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