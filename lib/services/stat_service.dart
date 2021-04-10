import 'package:lotto_mate/commons/lotto_color.dart';
import 'package:lotto_mate/commons/lotto_even_odd.dart';
import 'package:lotto_mate/models/stat.dart';
import 'package:lotto_mate/repositories/repository.dart';

class StatService {
  final Repository _repository = Repository('stat');

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

  Future<List<Map<String, dynamic>>> _getStat(
      {int? startId, int? endId}) async {
    String sql = '''
      select
        drawNumber1,
        drawNumber2,
        drawNumber3,
        drawNumber4,
        drawNumber5,
        drawNumber6,
        drawNumberBo
      from draws
    ''';
    List<dynamic> args = [];
    if (startId != null && endId != null) {
      sql += 'where id >= ? and id <= ?';
      args = [startId, endId];
    }

    return await _repository.getRawQuery(sql, arguments: args);
  }
}
