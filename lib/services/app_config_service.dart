import 'package:lotto_mate/models/app_config.dart';
import 'package:lotto_mate/repositories/repository.dart';
import 'package:sqflite/sqflite.dart';

class AppConfigService {
  final Repository _repository = Repository('appConfig');

  getConfigValue(String configId) async {
    var config = await _repository.getByWhere(
      where: 'configId = ?',
      whereArgs: [configId],
    );

    if (config.length > 0) {
      return AppConfig.fromDb(config.first);
    }

    return null;
  }

  setConfigValue(AppConfig config) async {
    await _repository.insert(
      config.toDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
