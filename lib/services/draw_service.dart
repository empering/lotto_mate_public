import 'package:lotto_mate/models/draw.dart';
import 'package:lotto_mate/models/draw_history.dart';
import 'package:lotto_mate/models/prize.dart';
import 'package:lotto_mate/repositories/repository.dart';

class DrawService {
  final Repository _drawRepository = Repository('draws');
  final Repository _prizeRepository = Repository('prizes');

  Future<void> save(Draw draw) async {
    await _drawRepository.insert(draw.toDb());

    await Future.forEach<Prize>(
        draw.prizes!, (prize) => _prizeRepository.insert(prize.toDb()));
  }

  Future<Draw?> getLast() async {
    var list = await _drawRepository.getByWhere(orderBy: 'id desc', limit: 1);
    if (list.length > 0) {
      return Draw.fromDb(list.first);
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
        count(id) as drawCount,
        sum(totalSellAmount) as buyAmount,
        sum(totalFirstPrizeAmount) as winAmount,
        sum(firstPrizewinnerCount) as winCount
      from draws
    ''';
    var args = [];
    if (startId != null && endId != null) {
      sql += 'where id >= ? and id <= ?';
      args = [startId, endId];
    }

    var list = await _drawRepository.getRawQuery(sql, arguments: args);
    return DrawHistory.fromDb(list.first);
  }
}
