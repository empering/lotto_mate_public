import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lotto_mate/commons/app_notification.dart';
import 'package:lotto_mate/models/app_config.dart';
import 'package:lotto_mate/services/app_config_service.dart';
import 'package:lotto_mate/widgets/app_text_button.dart';

class AppConfigState with ChangeNotifier {
  final AppConfigService _configService;

  AppConfigState(this._configService);

  String configId = 'NOTI';

  AppConfig? _appConfig;

  AppConfig? get appConfig => _appConfig;

  bool get appConfigValue => _appConfig?.configValue == 'Y';

  initialize() async {
    var config = await _configService.getConfigValue(configId);

    _appConfig = config ?? AppConfig(configId: configId);

    _setNotification();

    notifyListeners();
  }

  setConfigValue(bool value) async {
    _appConfig!.configValue = value ? 'Y' : 'N';

    _setNotification();
    _saveConfigValue();

    notifyListeners();
  }

  requestNotifyPermission() async {
    if (_appConfig?.configValue == null) {
      Get.defaultDialog(
        title: '확인해주세요',
        middleText: '알림설정 동의 하시면\n매주 토요일 오후 9시\n당첨결과 발표 시 알려드려요.',
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppTextButton(
                labelIcon: Icons.check_circle_outline,
                labelText: '동의',
                onPressed: () async {
                  setConfigValue(true);
                  Get.back();
                },
              ),
              AppTextButton(
                labelIcon: Icons.cancel_outlined,
                labelText: '거절',
                onPressed: () {
                  setConfigValue(false);
                  Get.back();
                },
              ),
            ],
          )
        ],
      );
    }
  }

  _setNotification() {
    print(_appConfig!.configValue);
    if (_appConfig!.configValue == 'Y') {
      AppNotification.zonedSchedule(
        title: '로또 당첨결과가 발표되었어요',
        body: '로또 메이트와 함께 어서 확인해보세요!',
      );
    } else {
      AppNotification.cancelNotification();
    }
  }

  _saveConfigValue() {
    _configService.setConfigValue(_appConfig!);
  }
}
