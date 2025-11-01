import 'dart:convert';
import 'package:flutter/foundation.dart'; // Để dùng debugPrint
import 'package:note_taking_app/models/note.dart';
import 'package:note_taking_app/repositories/note_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebNoteRepository implements NoteRepository {
  final SharedPreferences prefs;
  
  WebNoteRepository({required this.prefs});

  static const String _kNoteIndexKey = 'note_index_v1';
  
  String _noteKey(String id) => 'note_item_$id';

  List<String> _getNoteIndex() {
    return prefs.getStringList(_kNoteIndexKey) ?? [];
  }
  
  Future<void> _saveNoteIndex(List<String> index) async {
    await prefs.setStringList(_kNoteIndexKey, index);
  }
  
  @override
  Future<List<Note>> getAllNotes() async {
    final List<Note> notes = [];
    final List<String> noteIds = _getNoteIndex();

    for (final id in noteIds) {
      final String? noteJson = prefs.getString(_noteKey(id));
      if (noteJson != null) {
        try {
          final Map<String, dynamic> noteMap = jsonDecode(noteJson) as Map<String, dynamic>;
          notes.add(Note.fromMap(noteMap));
        } catch (e) {
          debugPrint("Lỗi giải mã (decode) ghi chú $id: $e");
          }
      }
    }
    
    notes.sort((a, b) => b.modifiedAt.compareTo(a.modifiedAt));
    
    return notes;
  }

  @override
  Future<Note?> getNoteById(String id) async {
    final String? noteJson = prefs.getString(_noteKey(id));
    
    if (noteJson == null) {
      return null;
    }

    try {
      final Map<String, dynamic> noteMap = jsonDecode(noteJson) as Map<String, dynamic>;
      return Note.fromMap(noteMap);
    } catch (e) {
      debugPrint("Lỗi giải mã (decode) ghi chú $id: $e");
      return null;
    }
  }

  @override
  Future<void> saveNote(Note note) async {
    final Map<String, dynamic> noteMap = note.toMap();
    final String noteJson = jsonEncode(noteMap);

    // 2. Lưu ghi chú bằng key riêng của nó
    await prefs.setString(_noteKey(note.id), noteJson);

    // 3. Cập nhật lại index (thêm ID nếu là ghi chú mới)
    final List<String> index = _getNoteIndex();
    if (!index.contains(note.id)) {
      index.add(note.id);
      await _saveNoteIndex(index);
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    await prefs.remove(_noteKey(id));

    final List<String> index = _getNoteIndex();
    if (index.contains(id)) {
      index.remove(id);
      await _saveNoteIndex(index);
    }
  }
}