import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static late Database _database;

  static Future<Database?> initDatabase() async {
    _database = await _initDatabase();
    return _database;
  }

  static Database get database => _database;

  static _initDatabase() async {
    return openDatabase(
      join(await (getDatabasesPath()), 'lotto_mate.db'),
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
