import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:lotto_mate/commons/lotto_color.dart';
import 'package:lotto_mate/commons/lotto_even_odd.dart';

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

  Map<LottoEvenOddType, int> _requiredMinEvenOddCount = {
    LottoEvenOddType.odd: 0,
    LottoEvenOddType.even: 0,
  };

  Map<LottoEvenOddType, int> _evenOdd = {
    LottoEvenOddType.odd: 0,
    LottoEvenOddType.even: 0,
  };

  List<int> get numbers => _numbers.toList()..sort();

  Map<LottoColors, int> get colors => _colors;

  Map<LottoEvenOddType, int> get evenOdd => _evenOdd;

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
    _requiredMinEvenOddCount.updateAll((_, __) => 0);

    _numbers.forEach((number) {
      var color = LottoColor.getLottoNumberColorEnum(number);
      var evenOdd = LottoEvenOdd.getEvenOddType(number);

      _requiredMinColorsCount[color] =
          (_requiredMinColorsCount[color] ?? 0) + 1;

      _requiredMinEvenOddCount[evenOdd] =
          (_requiredMinEvenOddCount[evenOdd] ?? 0) + 1;
    });

    _requiredMinColorsCount.forEach((color, count) {
      // if (count > (_colors[color] ?? 0)) {
      _setColorCount(color, count, isNotify: false);
      // }
    });

    _requiredMinEvenOddCount.forEach((evenOdd, count) {
      setEvenOddCount(evenOdd, count, isNotify: false);
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

  plusColorCount(LottoColors color) {
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

  minusEvenOddCount(LottoEvenOddType evenOdd) {
    int targetCount = _evenOdd[evenOdd] ?? 0;
    int minimunCount = _requiredMinEvenOddCount[evenOdd] ?? 0;

    if (targetCount > minimunCount) {
      setEvenOddCount(evenOdd, --targetCount);
    }
  }

  plusEvenOddCount(LottoEvenOddType evenOdd) {
    int targetCount = _evenOdd[evenOdd] ?? 0;
    int maximunCount = 6;

    if (targetCount < maximunCount) {
      setEvenOddCount(evenOdd, ++targetCount);
    }
  }

  setEvenOddCount(LottoEvenOddType evenOdd, int count, {bool isNotify = true}) {
    var totalCount = count;
    _evenOdd.forEach((key, value) {
      if (key != evenOdd) {
        totalCount += value;
      }
    });

    if (totalCount <= 6) {
      _evenOdd[evenOdd] = count;
    } else {}

    if (isNotify) {
      notifyListeners();
    }
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
    Set<int> generateNumbers = _numbers.toSet();

    Map<LottoColors, int> requiredGenerateColorsCount = Map.from(_colors);

    _numbers.forEach((number) {
      LottoColors color = LottoColor.getLottoNumberColorEnum(number);
      requiredGenerateColorsCount[color] =
          requiredGenerateColorsCount[color]! - 1;
    });

    requiredGenerateColorsCount.forEach((color, count) {
      if (count > 0) {
        int limitIndex = generateNumbers.length + count;
        while (generateNumbers.length < limitIndex) {
          generateNumbers.add(_generateNumberByColor(color));
        }
      }
    });

    while (generateNumbers.length < 6) {
      generateNumbers.add(_generateNumber());
    }

    return generateNumbers.toList()..sort();
  }

  _generateNumberByColor(LottoColors color) {
    int min = 1;
    int max = 45;

    switch (color) {
      case LottoColors.yellow:
        min = 1;
        max = 10;
        break;
      case LottoColors.blue:
        min = 11;
        max = 10;
        break;
      case LottoColors.red:
        min = 21;
        max = 10;
        break;
      case LottoColors.gray:
        min = 31;
        max = 10;
        break;
      case LottoColors.green:
        min = 41;
        max = 5;
        break;
      default:
        min = 1;
        max = 45;
    }

    return _generateNumber(min: min, max: max);
  }

  _generateNumber({int min = 1, int max = 45}) {
    var random = Random();
    return random.nextInt(max) + min;
  }
}
