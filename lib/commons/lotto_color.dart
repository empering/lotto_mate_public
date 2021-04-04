import 'package:flutter/material.dart';

enum LottoColorType {
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

  static Color getLottoColor(LottoColorType color) {
    switch (color) {
      case LottoColorType.yellow:
        return yellow;
      case LottoColorType.blue:
        return blue;
      case LottoColorType.red:
        return red;
      case LottoColorType.gray:
        return gray;
      case LottoColorType.green:
        return green;
      case LottoColorType.none:
        return none;
    }
  }

  static String getLottoColorTypeName(LottoColorType color) {
    switch (color) {
      case LottoColorType.yellow:
        return '노랑';
      case LottoColorType.blue:
        return '파랑';
      case LottoColorType.red:
        return '빨강';
      case LottoColorType.gray:
        return '회색';
      case LottoColorType.green:
        return '초록';
      case LottoColorType.none:
        return '';
    }
  }

  static LottoColorType getLottoNumberColorType(int number) {
    switch ((number - 1) ~/ 10) {
      case 0:
        return LottoColorType.yellow;
      case 1:
        return LottoColorType.blue;
      case 2:
        return LottoColorType.red;
      case 3:
        return LottoColorType.gray;
      case 4:
        return LottoColorType.green;
    }

    return LottoColorType.none;
  }

  static Color getLottoNumberColor(int number) {
    return getLottoColor(getLottoNumberColorType(number));
  }

  static String getLottoNumberColorName(int number) {
    return getLottoColorTypeName(getLottoNumberColorType(number));
  }
}
