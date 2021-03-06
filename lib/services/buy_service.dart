import 'package:lotto_mate/models/buy.dart';
import 'package:lotto_mate/models/draw.dart';
import 'package:lotto_mate/models/draw_history.dart';
import 'package:lotto_mate/models/prize.dart';
import 'package:lotto_mate/repositories/repository.dart';
import 'package:sqflite/sqlite_api.dart';

class BuyService {
  final Repository _buyRepository = Repository('buys');
  final Repository _pickRepository = Repository('picks');
  final Repository _pickResultRepository = Repository('pickResult');

  Future<Buy> save(Buy buy) async {
    int id = await _buyRepository.insert(buy.toDb());

    await Future.forEach<Pick>(buy.picks!, (pick) async {
      pick.buyId = id;
      await _pickRepository.insert(pick.toDb());
    });

    var buys = await _buyRepository
        .getByWhere(
          where: 'id = ?',
          whereArgs: [id],
          limit: 1,
        )
        .then(
            (buysMap) => buysMap.map((buyMap) => Buy.fromDb(buyMap)).toList());

    await Future.forEach(
      buys,
      (Buy buy) => _pickRepository.getByWhere(
          where: "buyId = ?", whereArgs: [buy.id]).then((picksMap) async {
        buy.picks =
            picksMap.map<Pick>((pickMap) => Pick.fromDb(pickMap)).toList();
      }),
    );

    return buys.first;
  }

  delete(Buy buy) async {
    await Future.forEach<Pick>(buy.picks!, (pick) async {
      await _pickResultRepository.delete(
        where: 'pickId = ?',
        whereArgs: [pick.id],
      );
      await _pickRepository.delete(
        where: 'id = ?',
        whereArgs: [pick.id],
      );
    });

    await _buyRepository.delete(where: 'id = ?', whereArgs: [buy.id]);
  }

  Future<List<Buy>> getAll({int? limit, int? offset}) async {
    List<Buy> buys = await _buyRepository
        .getByWhere(
          orderBy: "drawId desc",
          limit: limit,
          offset: offset,
        )
        .then(
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

  Future<List<Buy>> getByDrawId(int drawId) async {
    List<Buy> buys = await _buyRepository.getByWhere(
      where: 'drawId = ?',
      whereArgs: [drawId],
    ).then((buyMap) => buyMap.map((map) => Buy.fromDb(map)).toList());

    await Future.forEach<Buy>(buys, (buy) async {
      await _pickRepository.getByWhere(
          where: 'buyId = ?', whereArgs: [buy.id]).then((picksMap) async {
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
      });
    });

    return buys;
  }

  savePickResult(PickResult pickResult) async {
    await _pickResultRepository.insert(pickResult.toDb(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  PickResult calcPickResult(Pick pick, Draw draw) {
    int rank = _getRank(pick, draw.numbers!);

    var pickResult = PickResult();
    pickResult.pickId = pick.id;
    pickResult.rank = rank;
    pickResult.rankName = rank > 0 ? '$rank???' : '??????';
    pickResult.amount = rank == 5
        ? 5000
        : draw.prizes!
            .singleWhere(
              (p) => p.rank == rank,
              orElse: () => Prize(eachAmount: 0),
            )
            .eachAmount;

    return pickResult;
  }

  int _getRank(Pick pick, List<int?> numbers) {
    int rank = 0;
    int count = 0;
    numbers.take(6).forEach((drawNumber) {
      if (pick.numbers!.contains(drawNumber)) {
        count++;
      }
    });

    switch (count) {
      case 6:
        rank = 1;
        break;

      case 5:
        {
          if (pick.numbers!.contains(numbers.last)) {
            rank = 2;
          } else {
            rank = 3;
          }
        }
        break;

      case 4:
        rank = 4;
        break;

      case 3:
        rank = 5;
        break;
    }

    return rank;
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
      sql += 'where a.drawId >= ? and a.drawId <= ?';
      args = [startId, endId];
    }

    var list = await _buyRepository.getRawQuery(sql, arguments: args);
    return DrawHistory.fromDb(list.first);
  }
}
