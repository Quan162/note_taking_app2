
import 'package:note_taking_app/helpers/database_helper.dart';
import 'package:note_taking_app/models/note.dart';

class NoteRepository {
  // Lấy instance singleton của DatabaseHelper
  final DatabaseHelper _dbHelper = DatabaseHelper();
  
  // Tên bảng
  static const String _tableName = 'notes';

  /// Lấy tất cả các Note, sắp xếp theo ngày sửa đổi gần nhất
  Future<List<Note>> getAllNotes() async {
    final List<Map<String, dynamic>> maps = await _dbHelper.getAll(
      _tableName,
      orderBy: 'modifiedAt DESC', // Sắp xếp note mới nhất lên đầu
    );

    // Chuyển đổi List<Map> thành List<Note>
    return List.generate(maps.length, (i) {
      return Note.fromJson(maps[i]);
    });
  }

  /// Lấy một Note cụ thể bằng ID
  Future<Note?> getNoteById(String id) async {
    final map = await _dbHelper.getById(_tableName, id);
    if (map != null) {
      return Note.fromJson(map);
    }
    return null;
  }

  /// Lưu một Note (tạo mới hoặc cập nhật)
  /// Vì helper dùng 'ConflictAlgorithm.replace', hàm này dùng được cho cả 2
  Future<void> saveNote(Note note) async {
    await _dbHelper.insertOrUpdate(
      _tableName,
      note.toJson(), // Chuyển Note object thành Map
    );
  }

  /// Xóa một Note bằng ID
  Future<void> deleteNote(String id) async {
    await _dbHelper.delete(_tableName, id);
  }
}