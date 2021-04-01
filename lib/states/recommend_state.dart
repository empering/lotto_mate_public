import 'dart:math';

import 'package:flutter/foundation.dart';

enum LottoColors {
  yellow,
  blue,
  red,
  gray,
  green,
}

enum LottoEvenOdd { even, odd }

class RecommendState with ChangeNotifier {
  Set<int> _numbers = {};
  Map<LottoColors, int> _colors = {
    LottoColors.yellow: 0,
    LottoColors.blue: 0,
    LottoColors.red: 0,
    LottoColors.gray: 0,
    LottoColors.green: 0,
  };

  Map<LottoEvenOdd, int> _evenOdd = {
    LottoEvenOdd.odd: 0,
    LottoEvenOdd.even: 0,
  };

  bool numberAddable = true;

  Set<int> get numbers => _numbers;

  Map<LottoColors, int> get colors => _colors;

  Map<LottoEvenOdd, int> get evenOdd => _evenOdd;

  bool isContains(int number) {
    return _numbers.contains(number);
  }

  addNumber(int number) {
    _numbers.add(number);

    _numbers = (_numbers.toList()..sort()).toSet();

    numberAddable = _numbers.length < 6;

    notifyListeners();
  }

  removeNumber(int number) {
    _numbers.remove(number);

    numberAddable = _numbers.length < 6;

    notifyListeners();
  }

  clearNumbers() {
    _numbers.clear();

    numberAddable = true;

    notifyListeners();
  }

  setColorCount(LottoColors color, int count) {
    _colors[color] = count;

    notifyListeners();
  }

  getColorName(LottoColors color) {
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
    }
  }

  setEvenOddCount(LottoEvenOdd evenOdd, int count) {
    _evenOdd[evenOdd] = count;

    notifyListeners();
  }

  Future<List<List<int>>> getRecommends({int loopCount = 5}) async {
    await Future.delayed(Duration(seconds: 2));

    List<List<int>> recommends = [];
    for (var i = 0; i < loopCount; i++) {
      recommends.add(_generateNumbers());
    }

    return recommends;
  }

  _generateNumbers() {
    var random = Random();
    Set<int> generateNumbers = {};
    while (generateNumbers.length < 6) {
      generateNumbers.add(random.nextInt(45) + 1);
    }

    return generateNumbers.toList()..sort();
  }
}
