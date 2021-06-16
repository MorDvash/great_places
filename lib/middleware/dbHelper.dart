import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class DbHelper {
  static Future<sql.Database> openDb() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'places.db'), onCreate: (db, v) {
      return db.execute(
          'CREATE TABLE user_place(id TEXT PRIMARY KEY, title TEXT, image TEXT)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DbHelper.openDb();
    db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DbHelper.openDb();
    return db.query(table);
  }
}
