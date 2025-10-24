import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  static const String _dbName = 'note_taking_database.db';
  static const String _notesTable = 'notes';

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  // Hàm khởi tạo database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        // Chạy câu lệnh CREATE TABLE
        return db.execute(
          'CREATE TABLE IF NOT EXISTS $_notesTable (id TEXT PRIMARY KEY,title TEXT NOT NULL,content TEXT NOT NULL,createdAt TEXT NOT NULL,modifiedAt TEXT NOT NULL,isFavorite INTEGER NOT NULL DEFAULT 0);',
        );
      },
    );
  }

  // --- Các hàm CRUD cơ bản ---

  /// Chèn hoặc Cập nhật (Upsert)
  /// Dùng ConflictAlgorithm.replace để nếu 'id' đã tồn tại, nó sẽ thay thế
  Future<int> insertOrUpdate(String table, Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert(
      table,
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Lấy tất cả các dòng
  Future<List<Map<String, dynamic>>> getAll(String table, {String? orderBy}) async {
    final db = await database;
    return await db.query(table, orderBy: orderBy);
  }

  /// Lấy một dòng theo ID
  Future<Map<String, dynamic>?> getById(String table, String id) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  /// Xóa một dòng theo ID
  Future<int> delete(String table, String id) async {
    final db = await database;
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}