import 'package:lotto_mate/commons/lotto_color.dart';
import 'package:lotto_mate/commons/lotto_even_odd.dart';
import 'package:lotto_mate/models/draw.dart';
import 'package:lotto_mate/models/stat.dart';
import 'package:lotto_mate/repositories/repository.dart';

class StatService {
  final Repository _repository = Repository('draws');

  getNumberStat({
    int? startId,
    int? endId,
    bool isWithBounsNumber = false,
  }) async {
    var result = await _getStat(startId: startId, endId: endId);

    List<Stat<int>> stats = List<Stat<int>>.generate(
        45, (i) => Stat<int>(i + 1, totCount: result.length));

    result.forEach((map) {
      for (var suffix = 1; suffix <= 6; suffix++) {
        int number = map['drawNumber$suffix'];
        stats.singleWhere((stat) => stat.statType == number)..count += 1;
      }

      if (isWithBounsNumber) {
        int number = map['drawNumberBo'];
        stats.singleWhere((stat) => stat.statType == number)..count += 1;
      }
    });

    return stats;
  }

  getColorStat({
    int? startId,
    int? endId,
    bool isWithBounsNumber = false,
  }) async {
    var result = await _getStat(startId: startId, endId: endId);

    List<Stat<LottoColorType>> stats = List<Stat<LottoColorType>>.generate(
      5,
      (i) => Stat<LottoColorType>(
        LottoColorType.values[i],
        totCount: result.length,
      ),
    );

    result.forEach((map) {
      for (var suffix = 1; suffix <= 6; suffix++) {
        int number = map['drawNumber$suffix'];
        stats.singleWhere((stat) =>
            stat.statType == LottoColor.getLottoNumberColorType(number))
          ..count += 1;
      }

      if (isWithBounsNumber) {
        int number = map['drawNumberBo'];
        stats.singleWhere((stat) =>
            stat.statType == LottoColor.getLottoNumberColorType(number))
          ..count += 1;
      }
    });

    return stats;
  }

  getEvenOddStat({
    int? startId,
    int? endId,
    bool isWithBounsNumber = false,
  }) async {
    var result = await _getStat(startId: startId, endId: endId);

    List<Stat<LottoEvenOddType>> stats = List<Stat<LottoEvenOddType>>.generate(
      2,
      (i) => Stat<LottoEvenOddType>(
        LottoEvenOddType.values[i],
        totCount: result.length,
      ),
    );

    result.forEach((map) {
      for (var suffix = 1; suffix <= 6; suffix++) {
        int number = map['drawNumber$suffix'];
        stats.singleWhere(
            (stat) => stat.statType == LottoEvenOdd.getEvenOddType(number))
          ..count += 1;
      }

      if (isWithBounsNumber) {
        int number = map['drawNumberBo'];
        stats.singleWhere(
            (stat) => stat.statType == LottoEvenOdd.getEvenOddType(number))
          ..count += 1;
      }
    });

    return stats;
  }

  getSeriesStat({int? startId, int? endId}) async {
    var result = await _getStat(startId: startId, endId: endId);

    List<SeriesStat> stats =
        List<SeriesStat>.generate(5, (i) => SeriesStat(6 - i));

    result.forEach((map) {
      int seriesSize = 1;
      int prevNumber = map['drawNumber1'];
      for (var suffix = 2; suffix <= 7; suffix++) {
        int curNumber = suffix == 7 ? 0 : map['drawNumber$suffix'];
        if (curNumber - prevNumber == 1) {
          seriesSize += 1;
        } else if (seriesSize > 1) {
          stats.singleWhere((stat) => stat.statType == seriesSize)
            ..draws.add(Draw.fromDb(map))
            ..count += 1;

          seriesSize = 1;
        }

        prevNumber = curNumber;
      }
    });

    return stats;
  }

  getUnpickStat({
    int? startId,
    int? endId,
    bool isWithBounsNumber = false,
  }) async {
    var result = await _getStat(startId: startId, endId: endId);

    var numberList = List<int>.generate(45, (i) => i + 1);

    result.forEach((map) {
      for (var suffix = 1; suffix <= 6; suffix++) {
        int number = map['drawNumber$suffix'];
        numberList.remove(number);
      }

      if (isWithBounsNumber) {
        int number = map['drawNumberBo'];
        numberList.remove(number);
      }
    });

    if (numberList.length == 0) {
      numberList.add(-999);
    }

    return numberList;
  }

  getRankStat({
    int? startId,
    int? endId,
    bool isWithBounsNumber = false,
  }) async {
    String sql = '''
      select
        b.rank,
        sum(winnerCount) as winnerCount,
        sum(totalSellAmount / 1000) as sellCount
      from draws a
      join prizes b
      on a.id = b.drawId
    ''';

    var args = [];
    if (startId != null && endId != null) {
      sql += 'where a.id >= ? and a.id <= ?';
      args = [startId, endId];
    }
    sql += '\ngroup by rank';

    var result = await _repository.getRawQuery(sql, arguments: args);

    return result;
  }

  Future<List<Map<String, dynamic>>> _getStat(
      {int? startId, int? endId}) async {
    return await _repository
        .getByWhere(where: 'id >= ? and id <= ?', whereArgs: [startId, endId]);
  }
}
