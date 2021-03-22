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
          CREATE TABLE draws (
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
          CREATE TABLE buys (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            drawId INTEGER
          )
          ''',
        );

        await db.execute(
          '''
          CREATE TABLE picks (
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
      },
      onUpgrade: (db, oldVersion, newVersion) async {

        // 추첨정보 테이블 추가
        if (oldVersion <= 2) {
          await db.execute(
            '''
              CREATE TABLE draws (
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
        }

        // 상금정보 테이블 추가
        if (oldVersion <= 3) {
          await db.execute(
            '''
              CREATE TABLE prizes (
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
        }

        // 당첨이력 테이블 추가
        if (oldVersion <= 4) {
          await db.execute(
            '''
              CREATE TABLE pickResult (
                pickId INTEGER PRIMARY KEY,
                rank INTEGER,
                amount NUMERIC,
                CONSTRAINT pickResult_fk FOREIGN KEY(pickId)
                REFERENCES picks(id)
              )
              ''',
          );
        }
      },
      version: 4,
    );
  }
}
