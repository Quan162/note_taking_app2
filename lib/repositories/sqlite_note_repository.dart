
import 'package:note_taking_app/helpers/database_helper.dart';
import 'package:note_taking_app/models/note.dart';
import 'package:note_taking_app/repositories/note_repository.dart';

class SqliteNoteRepository extends NoteRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  
  static const String _tableName = 'notes';

  @override
  Future<List<Note>> getAllNotes() async {
    final List<Map<String, dynamic>> maps = await _dbHelper.getAll(
      _tableName,
      orderBy: 'modifiedAt DESC', // Sắp xếp note mới nhất lên đầu
    );

    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  @override
  Future<Note?> getNoteById(String id) async {
    final map = await _dbHelper.getById(_tableName, id);
    if (map != null) {
      return Note.fromMap(map);
    }
    return null;
  }

  @override
  Future<void> saveNote(Note note) async {
    await _dbHelper.insertOrUpdate(
      _tableName,
      note.toMap(), 
    );
  }

  @override
  Future<void> deleteNote(String id) async {
    await _dbHelper.delete(_tableName, id);
  }
}