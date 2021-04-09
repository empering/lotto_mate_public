import 'package:lotto_mate/models/stat.dart';
import 'package:lotto_mate/repositories/repository.dart';

class StatService {
  final Repository _repository = Repository('stat');

  getNumberStat(
      {int? startId, int? endId, bool isWithBounsNumber = false}) async {
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

    var result = await _repository.getRawQuery(sql, arguments: args);
    List<Stat<int>> stats = List<Stat<int>>.generate(
        45, (i) => Stat<int>(i + 1, totCount: result.length));

    result.forEach((map) {
      for (var suffix = 1; suffix <= 6; suffix++) {
        int number = map['drawNumber$suffix'] - 1;
        stats[number].count += 1;
      }

      if (isWithBounsNumber) {
        int number = map['drawNumberBo'] - 1;
        stats[number].count += 1;
      }
    });

    return stats;
  }
}
