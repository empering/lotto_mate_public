import 'package:flutter/material.dart';

enum LottoColors {
  none,
  yellow,
  blue,
  red,
  gray,
  green,
}

class LottoColor {
  static const none = Colors.white24;
  static final Color notMatched = Colors.grey.withOpacity(0.35);
  static const yellow = Color.fromRGBO(251, 196, 0, 1);
  static const blue = Color.fromRGBO(105, 200, 242, 1);
  static const red = Color.fromRGBO(255, 114, 114, 1);
  static const gray = Color.fromRGBO(170, 170, 170, 1);
  static const green = Color.fromRGBO(176, 216, 64, 1);

  static Color getLottoColor(LottoColors color) {
    switch (color) {
      case LottoColors.yellow:
        return yellow;
      case LottoColors.blue:
        return blue;
      case LottoColors.red:
        return red;
      case LottoColors.gray:
        return gray;
      case LottoColors.green:
        return green;
      case LottoColors.none:
        return none;
    }
  }

  static String getLottoColorName(LottoColors color) {
    switch (color) {
      case LottoColors.yellow:
        return '노랑';
      case LottoColors.blue:
        return '파랑';
      case LottoColors.red:
        return '빨강';
      case LottoColors.gray:
        return '회색';
      case LottoColors.green:
        return '초록';
      case LottoColors.none:
        return '';
    }
  }

  static LottoColors getLottoNumberColorEnum(int number) {
    switch ((number - 1) ~/ 10) {
      case 0:
        return LottoColors.yellow;
      case 1:
        return LottoColors.blue;
      case 2:
        return LottoColors.red;
      case 3:
        return LottoColors.gray;
      case 4:
        return LottoColors.green;
    }

    return LottoColors.none;
  }

  static Color getLottoNumberColor(int number) {
    return getLottoColor(getLottoNumberColorEnum(number));
  }

  static String getLottoNumberColorName(int number) {
    return getLottoColorName(getLottoNumberColorEnum(number));
  }
}
