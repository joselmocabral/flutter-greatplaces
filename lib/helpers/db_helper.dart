import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {

  static Future<Database> database() async{
    final dbPath = await sql.getDatabasesPath();
    return  sql.openDatabase(path.join(dbPath, 'places9.db'),
        onCreate: (db, version) {
          return db.execute('CREATE TABLE user_places4(id TEXT PRIMARY KEY, title TEXT, memory TEXT, date TEXT, image TEXT, loc_lat REAL, loc_lng REAL, address TEXT)');
        }, version: 1);

  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final sqlDb = await DBHelper.database();
    sqlDb.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async{
    final sqlDb = await DBHelper.database();
    return sqlDb.query(table);
  }

  static Future<void> delete(String table, String id) async {
    final sqlDb = await DBHelper.database();
    sqlDb.rawDelete('DELETE FROM user_places4 WHERE id = ?', ['$id']);
    //sqlDb.delete(table, where: '$id = ?', whereArgs: [id]);
  }

  
}
