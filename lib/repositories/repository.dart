import 'package:lotto_mate/commons/db_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';

class Repository {
  final Database _db = DbHelper.database;
  final String _tableName;

  Repository(this._tableName);

  Future<int> insert(Map<String, dynamic> json,
      {ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.abort}) async {
    return _db.insert(this._tableName, json,
        conflictAlgorithm: conflictAlgorithm);
  }

  delete({String? where, List<dynamic>? whereArgs}) {
    return _db.delete(
      this._tableName,
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<List<Map<String, dynamic>>> getByWhere({
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    return _db.query(
      this._tableName,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  Future<List<Map<String, dynamic>>> getAll({String? orderBy}) async {
    return _db.query(this._tableName, orderBy: orderBy);
  }

  Future<List<Map<String, dynamic>>> getRawQuery(String sql,
      {List<Object?>? arguments}) async {
    return _db.rawQuery(sql, arguments);
  }
}
