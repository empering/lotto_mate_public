import 'package:lotto_mate/models/buy.dart';
import 'package:lotto_mate/models/draw_history.dart';
import 'package:lotto_mate/repositories/repository.dart';
import 'package:sqflite/sqlite_api.dart';

class BuyService {
  final Repository _buyRepository = Repository('buys');
  final Repository _pickRepository = Repository('picks');
  final Repository _pickResultRepository = Repository('pickResult');

  void save(Buy buy) async {
    int id = await _buyRepository.insert(buy.toDb());

    buy.picks!.forEach((pick) {
      pick.buyId = id;
      print(pick);
      _pickRepository.insert(pick.toDb());
    });
  }

  Future<List<Buy>> getAll() async {
    List<Buy> buys = await _buyRepository.getAll(orderBy: "drawId desc").then(
        (buysMap) => buysMap.map((buyMap) => Buy.fromDb(buyMap)).toList());

    await Future.forEach(
      buys,
      (Buy buy) => _pickRepository.getByWhere(
          where: "buyId = ?", whereArgs: [buy.id]).then((picksMap) async {
        buy.picks =
            picksMap.map<Pick>((pickMap) => Pick.fromDb(pickMap)).toList();

        if ((buy.picks ?? []).length > 0) {
          await Future.forEach(
            buy.picks!,
            (Pick pick) => _pickResultRepository.getByWhere(
                where: "pickId = ?",
                whereArgs: [pick.id]).then((pickResultMap) {
              pick.pickResult = pickResultMap.length == 0
                  ? PickResult()
                  : PickResult.fromDb(pickResultMap.first);
            }),
          );
        }
      }),
    );

    return buys;
  }

  void savePickResult(PickResult pickResult) async {
    await _pickResultRepository.insert(pickResult.toDb(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<DrawHistory> getBuySummary({int? startId, int? endId}) async {
    String sql = '''
      select
          count(distinct a.drawId) as drawCount,
          count(b.id) as buyCount,
          count(b.id) * 1000 as buyAmount,
          sum(c.amount) as winAmount,
          sum(case when c.rank > 0 then 1 else 0 end) as winCount
      from buys a
      join picks b
      on a.id = b.buyId
      join pickResult c
      on b.id = c.pickId
    ''';
    var args = [];
    if (startId != null && endId != null) {
      sql += 'where a.id >= ? and a.id <= ?';
      args = [startId, endId];
    }

    var list = await _buyRepository.getRawQuery(sql, arguments: args);
    return DrawHistory.fromDb(list.first);
  }
}
