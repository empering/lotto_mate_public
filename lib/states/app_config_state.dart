import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lotto_mate/commons/app_notification.dart';
import 'package:lotto_mate/models/app_config.dart';
import 'package:lotto_mate/services/app_config_service.dart';
import 'package:lotto_mate/widgets/app_text_button.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class AppConfigState with ChangeNotifier {
  final AppConfigService _configService;

  AppConfigState(this._configService);

  String configId = 'NOTI';

  AppConfig? _appConfig;

  AppConfig? get appConfig => _appConfig;

  bool get appConfigValue => _appConfig?.configValue == 'Y';

  String appVersion = '';
  String appBuildNumber = '';

  initialize(String buildNumer) async {
    var config = await _configService.getConfigValue(configId);

    _appConfig = config ?? AppConfig(configId: configId);

    _setNotification();

    var packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
    appBuildNumber = packageInfo.buildNumber;

    if (int.parse(appBuildNumber) <
        (buildNumer.isEmpty ? 1 : int.parse(buildNumer))) {
      await requestAppUpdate();
    }

    await requestNotifyPermission();

    notifyListeners();
  }

  setConfigValue(bool value) async {
    _appConfig!.configValue = value ? 'Y' : 'N';

    _setNotification();
    _saveConfigValue();

    notifyListeners();
  }

  requestAppUpdate() async {
    await Get.defaultDialog(
      title: '확인해주세요',
      middleText: '앱 업데이트 버전이 있어요.\n업데이트 하고 새로운 기능을 활용하세요.',
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppTextButton(
              labelIcon: Icons.check_circle_outline,
              labelText: '확인',
              onPressed: () async {
                await goMarket();
                Get.back();
              },
            ),
            AppTextButton(
              labelIcon: Icons.cancel_outlined,
              labelText: '취소',
              onPressed: () {
                Get.back();
              },
            ),
          ],
        )
      ],
    );
  }

  goMarket() async {
    await launch(
        'https://play.google.com/store/apps/details?id=com.lotto_mate');
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
