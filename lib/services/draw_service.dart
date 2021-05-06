import 'package:lotto_mate/models/draw.dart';
import 'package:lotto_mate/models/draw_history.dart';
import 'package:lotto_mate/models/prize.dart';
import 'package:lotto_mate/repositories/repository.dart';
import 'package:sqflite/sqflite.dart';

class DrawService {
  final Repository _drawRepository = Repository('draws');
  final Repository _prizeRepository = Repository('prizes');

  Future<void> save(Draw draw) async {
    var dbDraw =
        await _drawRepository.getByWhere(where: 'id = ?', whereArgs: [draw.id]);

    if (dbDraw.length > 0) {
      await _prizeRepository.delete(where: 'drawId = ?', whereArgs: [draw.id]);
    }

    await _drawRepository.insert(
      draw.toDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await Future.forEach<Prize>(
        draw.prizes!, (prize) => _prizeRepository.insert(prize.toDb()));
  }

  Future<Draw?> getLast() async {
    var list = await _drawRepository.getByWhere(orderBy: 'id desc', limit: 1);
    if (list.length > 0) {
      var draw = Draw.fromDb(list.first);
      draw.prizes = await _prizeRepository.getByWhere(
        where: 'drawId = ?',
        whereArgs: [draw.id],
      ).then((prizes) =>
          prizes.map((prizeMap) => Prize.fromDb(prizeMap)).toList());

      num totalAmount = 0;
      draw.prizes!.forEach((prize) {
        totalAmount += prize.totalAmount ?? 0;
      });

      if (totalAmount == 0) {
        draw.id = draw.id! - 1;
      }

      return draw;
    }
    return null;
  }

  Future<Draw?> getDrawById(int? drawId) async {
    var drawMap = await _drawRepository.getByWhere(
      where: 'id = ?',
      whereArgs: [drawId],
    );

    if (drawMap.length > 0) {
      Draw draw = Draw.fromDb(drawMap.first);
      draw.prizes = await _prizeRepository.getByWhere(
        where: 'drawId = ?',
        whereArgs: [drawId],
      ).then((prizes) =>
          prizes.map((prizeMap) => Prize.fromDb(prizeMap)).toList());

      return draw;
    }

    return null;
  }

  Future<List<Draw>> getDraws({int limit = 10, int offset = 0}) async {
    var list = await _drawRepository.getByWhere(
        orderBy: 'id desc', limit: limit, offset: offset);
    return list.map((drawMap) => Draw.fromDb(drawMap)).toList();
  }

  Future<DrawHistory> getDrawsSummary({int? startId, int? endId}) async {
    String sql = '''
      select
        a.*,
        (select drawId from prizes where eachAmount = maxWinAmount) as maxWinAmountDrawId,
        (select drawId from prizes where eachAmount = minWinAmount) as minWinAmountDrawId,
        (select drawId from prizes where eachAmount = maxEachWinAmount) as maxEachWinAmountDrawId,
        (select drawId from prizes where eachAmount = minEachWinAmount) as minEachWinAmountDrawId
      from (
        select
          count(a.id) as drawCount,
          sum(a.totalSellAmount) as buyAmount,
          sum(b.totalAmount) as winAmount,
          sum(b.winnerCount) as winCount,
          max(b.totalAmount) as maxWinAmount,
          min(case when b.totalAmount = 0 then null else b.totalAmount end) as minWinAmount,
          max(b.eachAmount) as maxEachWinAmount,
          min(case when b.winnerCount = 0 then null else b.eachAmount end) as minEachWinAmount
        from draws a
        join prizes b
        on a.id = b.drawId
        where b.rank = 1
    ''';
    var args = [];
    if (startId != null && endId != null) {
      sql += 'and a.id >= ? and a.id <= ?';
      args = [startId, endId];
    }
    sql += ') a';

    var list = await _drawRepository.getRawQuery(sql, arguments: args);
    return DrawHistory.fromDb(list.first);
  }
}
