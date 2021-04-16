import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static late Database _database;

  static Future<Database?> initDatabase() async {
    var dataBasePath = await getDatabasesPath();
    var path = join(dataBasePath, 'lotto_mate.db');

    var dbExists = await databaseExists(path);

    if (!dbExists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join("assets", "base.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    }

    _database = await _initDatabase(path);

    return _database;
  }

  static Database get database => _database;

  static _initDatabase(String path) async {
    return openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE IF NOT EXISTS draws (
            id INTEGER PRIMARY KEY,
            drawDate TEXT,
            drawNumber1 INTEGER,
            drawNumber2 INTEGER,
            drawNumber3 INTEGER,
            drawNumber4 INTEGER,
            drawNumber5 INTEGER,
            drawNumber6 INTEGER,
            drawNumberBo INTEGER,
            totalSellAmount NUMERIC,
            totalFirstPrizeAmount NUMERIC,
            eachFirstPrizeAmount NUMERIC,
            firstPrizewinnerCount INTEGER
          )
          ''',
        );

        await db.execute(
          '''
          CREATE TABLE IF NOT EXISTS buys (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            drawId INTEGER
          )
          ''',
        );

        await db.execute(
          '''
          CREATE TABLE IF NOT EXISTS picks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            buyId INTEGER,
            type TEXT,
            pickNumber1 INTEGER,
            pickNumber2 INTEGER,
            pickNumber3 INTEGER,
            pickNumber4 INTEGER,
            pickNumber5 INTEGER,
            pickNumber6 INTEGER,
            CONSTRAINT picks_fk FOREIGN KEY(buyId)
            REFERENCES buys(id)
          )
          ''',
        );

        await db.execute(
          '''
          CREATE TABLE IF NOT EXISTS draws (
            id INTEGER PRIMARY KEY,
            drawDate TEXT,
            drawNumber1 INTEGER,
            drawNumber2 INTEGER,
            drawNumber3 INTEGER,
            drawNumber4 INTEGER,
            drawNumber5 INTEGER,
            drawNumber6 INTEGER,
            drawNumberBo INTEGER,
            totalSellAmount NUMERIC,
            totalFirstPrizeAmount NUMERIC,
            eachFirstPrizeAmount NUMERIC,
            firstPrizewinnerCount INTEGER
          )
          ''',
        );

        await db.execute(
          '''
          CREATE TABLE IF NOT EXISTS prizes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            drawId INTEGER,
            rank INTEGER,
            totalAmount NUMERIC,
            winnerCount INTEGER,
            eachAmount NUMERIC,
            CONSTRAINT prizes_fk FOREIGN KEY(drawId)
            REFERENCES draws(id)
          )
          ''',
        );

        await db.execute(
          '''
          CREATE TABLE IF NOT EXISTS pickResult (
            pickId INTEGER PRIMARY KEY,
            rank INTEGER,
            amount NUMERIC,
            CONSTRAINT pickResult_fk FOREIGN KEY(pickId)
            REFERENCES picks(id)
          )
          ''',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {},
      version: 1,
    );
  }
}
