import 'dart:convert';
import 'package:flutter/foundation.dart'; // Để dùng debugPrint
import 'package:note_taking_app/models/note.dart';
import 'package:note_taking_app/repositories/note_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Đảm bảo NoteRepository là abstract class (lớp trừu tượng)
// và bạn đang 'implements' (triển khai) nó, không phải 'extends'.
class WebNoteRepository implements NoteRepository {
  // Bỏ dấu '?' vì 'required' đảm bảo nó không bao giờ null
  final SharedPreferences prefs;
  
  WebNoteRepository({required this.prefs});

  // Key hằng số cho danh sách index
  static const String _kNoteIndexKey = 'note_index_v1';
  
  // Helper để tạo key cho từng ghi chú
  String _noteKey(String id) => 'note_item_$id';

  // Helper lấy danh sách ID
  List<String> _getNoteIndex() {
    return prefs.getStringList(_kNoteIndexKey) ?? [];
  }
  
  // Helper lưu danh sách ID
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
          // Decode chuỗi JSON thành Map, rồi tạo đối tượng Note
          final Map<String, dynamic> noteMap = jsonDecode(noteJson) as Map<String, dynamic>;
          notes.add(Note.fromJson(noteMap));
        } catch (e) {
          debugPrint("Lỗi giải mã (decode) ghi chú $id: $e");
          // Có thể thêm logic xóa ID hỏng khỏi index ở đây
        }
      }
    }
    
    // Sắp xếp theo ngày sửa đổi, mới nhất lên đầu (Tùy chọn)
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
      return Note.fromJson(noteMap);
    } catch (e) {
      debugPrint("Lỗi giải mã (decode) ghi chú $id: $e");
      return null;
    }
  }

  @override
  Future<void> saveNote(Note note) async {
    // 1. Chuyển Note thành Map rồi thành chuỗi JSON
    final Map<String, dynamic> noteMap = note.toJson();
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
    // 1. Xóa ghi chú
    await prefs.remove(_noteKey(id));

    // 2. Xóa ID khỏi index
    final List<String> index = _getNoteIndex();
    if (index.contains(id)) {
      index.remove(id);
      await _saveNoteIndex(index);
    }
  }
}