import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:lotto_mate/commons/lotto_color.dart';

enum LottoEvenOdd { even, odd }

class RecommendState with ChangeNotifier {
  final int numbersLimitSize = 4;

  Set<int> _numbers = {};

  Map<LottoColors, int> _requiredMinColorsCount = {
    LottoColors.yellow: 0,
    LottoColors.blue: 0,
    LottoColors.red: 0,
    LottoColors.gray: 0,
    LottoColors.green: 0,
  };

  Map<LottoColors, int> _maxColorsCount = {
    LottoColors.yellow: 6,
    LottoColors.blue: 6,
    LottoColors.red: 6,
    LottoColors.gray: 6,
    LottoColors.green: 5,
  };

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

  List<int> get numbers => _numbers.toList()..sort();

  Map<LottoColors, int> get colors => _colors;

  Map<LottoEvenOdd, int> get evenOdd => _evenOdd;

  bool get numberAddable => _numbers.length < numbersLimitSize;

  bool isContains(int number) {
    return _numbers.contains(number);
  }

  addNumber(int number) {
    _numbers.add(number);
    _setNumber();
  }

  removeNumber(int number) {
    _numbers.remove(number);
    _setNumber();
  }

  clearNumbers() {
    _numbers.clear();
    _setNumber();
  }

  _setNumber() {
    _requiredMinColorsCount.updateAll((_, __) => 0);

    _numbers.forEach((number) {
      var color = LottoColor.getLottoNumberColorEnum(number);
      _requiredMinColorsCount[color] =
          (_requiredMinColorsCount[color] ?? 0) + 1;
    });

    _requiredMinColorsCount.forEach((color, count) {
      // if (count > (_colors[color] ?? 0)) {
      _setColorCount(color, count, isNotify: false);
      // }
    });

    notifyListeners();
  }

  minusColorCount(LottoColors color) {
    int targetCount = _colors[color] ?? 0;
    int minimunCount = _requiredMinColorsCount[color] ?? 0;

    if (targetCount > minimunCount) {
      _setColorCount(color, --targetCount);
    }
  }

  addColorCount(LottoColors color) {
    int targetCount = _colors[color] ?? 0;
    int maximunCount = _maxColorsCount[color] ?? 6;

    if (targetCount < maximunCount) {
      _setColorCount(color, ++targetCount);
    }
  }

  _setColorCount(LottoColors color, int count, {bool isNotify = true}) {
    var totalColorCount = count;
    _colors.forEach((key, value) {
      if (key != color) {
        totalColorCount += value;
      }
    });

    if (totalColorCount <= 6) {
      _colors[color] = count;
    } else {}

    if (isNotify) {
      notifyListeners();
    }
  }

  getColorName(LottoColors color) {
    return LottoColor.getLottoColorName(color);
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
    Set<int> generateNumbers = _numbers.toSet();
    while (generateNumbers.length < 6) {
      generateNumbers.add(random.nextInt(45) + 1);
    }

    return generateNumbers.toList()..sort();
  }
}
