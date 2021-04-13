import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lotto_mate/commons/lotto_color.dart';
import 'package:lotto_mate/commons/lotto_even_odd.dart';

class RecommendState with ChangeNotifier {
  final int numbersLimitSize = 4;

  final InterstitialAd _interstitialAd;

  RecommendState(this._interstitialAd);

  Set<int> _numbers = {};

  Map<LottoColorType, int> _requiredMinColorsCount = {
    LottoColorType.yellow: 0,
    LottoColorType.blue: 0,
    LottoColorType.red: 0,
    LottoColorType.gray: 0,
    LottoColorType.green: 0,
  };

  Map<LottoColorType, int> _maxColorsCount = {
    LottoColorType.yellow: 6,
    LottoColorType.blue: 6,
    LottoColorType.red: 6,
    LottoColorType.gray: 6,
    LottoColorType.green: 5,
  };

  Map<LottoColorType, int> _colors = {
    LottoColorType.yellow: 0,
    LottoColorType.blue: 0,
    LottoColorType.red: 0,
    LottoColorType.gray: 0,
    LottoColorType.green: 0,
  };

  Map<LottoEvenOddType, int> _requiredMinEvenOddCount = {
    LottoEvenOddType.odd: 0,
    LottoEvenOddType.even: 0,
  };

  Map<LottoEvenOddType, int> _evenOdd = {
    LottoEvenOddType.odd: 0,
    LottoEvenOddType.even: 0,
  };

  List<List<int>> _recommends = [];

  bool _isColorExpanded = false;

  bool _isEvenOddExpanded = false;

  InterstitialAd get interstitialAd => _interstitialAd;

  List<int> get numbers => _numbers.toList()..sort();

  Map<LottoColorType, int> get colors => _colors;

  Map<LottoEvenOddType, int> get evenOdd => _evenOdd;

  List<List<int>> get recommends => _recommends;

  bool get numberAddable => _numbers.length < numbersLimitSize;

  bool isContains(int number) {
    return _numbers.contains(number);
  }

  bool get isColorExpanded => _isColorExpanded;

  set isColorExpanded(bool value) {
    _isColorExpanded = value;
    notifyListeners();
  }

  bool get isEvenOddExpanded => _isEvenOddExpanded;

  set isEvenOddExpanded(bool value) {
    _isEvenOddExpanded = value;
    notifyListeners();
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
      var color = LottoColor.getLottoNumberColorType(number);
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
      _setEvenOddCount(evenOdd, count, isNotify: false);
    });

    notifyListeners();
  }

  minusColorCount(LottoColorType color) {
    int targetCount = _colors[color] ?? 0;
    int minimunCount = _requiredMinColorsCount[color] ?? 0;

    if (targetCount > minimunCount) {
      _setColorCount(color, --targetCount);
    }
  }

  plusColorCount(LottoColorType color) {
    int targetCount = _colors[color] ?? 0;
    int maximunCount = _maxColorsCount[color] ?? 6;

    if (targetCount < maximunCount) {
      _setColorCount(color, ++targetCount);
    }
  }

  _setColorCount(LottoColorType color, int count, {bool isNotify = true}) {
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

  minusEvenOddCount(LottoEvenOddType evenOdd) {
    int targetCount = _evenOdd[evenOdd] ?? 0;
    int minimunCount = _requiredMinEvenOddCount[evenOdd] ?? 0;

    if (targetCount > minimunCount) {
      _setEvenOddCount(evenOdd, --targetCount);
    }
  }

  plusEvenOddCount(LottoEvenOddType evenOdd) {
    int targetCount = _evenOdd[evenOdd] ?? 0;
    int maximunCount = 6;

    if (targetCount < maximunCount) {
      _setEvenOddCount(evenOdd, ++targetCount);
    }
  }

  _setEvenOddCount(LottoEvenOddType evenOdd, int count,
      {bool isNotify = true}) {
    var totalCount = count;
    _evenOdd.forEach((key, value) {
      if (key != evenOdd) {
        totalCount += value;
      }
    });

    int limitCount = 6;

    _colors.forEach((color, count) {
      if (LottoColorType.green == color && count == 5) {
        limitCount = LottoEvenOddType.even == evenOdd ? 3 : 4;
      } else if (count == 6) {
        limitCount = 5;
      }
    });

    // 초록색을 5개 선택한 경우 나머지 한가지 숫자에 따라 홀,짝 조건을 만족 못하는 경우가 생김
    if (limitCount <= 4) {
      // if LottoColorType.green
      int notGreenNumber = _numbers.firstWhere(
        (number) => number < 41,
        orElse: () => 0,
      );
      if (notGreenNumber != 0 &&
          ((notGreenNumber.isEven && LottoEvenOddType.even != evenOdd) ||
              (notGreenNumber.isOdd && LottoEvenOddType.odd != evenOdd))) {
        limitCount -= 1;
      }
    }

    if (totalCount <= 6 && count <= limitCount) {
      _evenOdd[evenOdd] = count;
    } else {}

    if (isNotify) {
      notifyListeners();
    }
  }

  getRecommends({int loopCount = 5}) async {
    _recommends = [];

    notifyListeners();

    await _interstitialAd.load();

    await Future.delayed(Duration(seconds: 2));

    List<List<int>> recommends = [];
    for (var i = 0; i < loopCount; i++) {
      recommends.add(_generateNumbers());
    }

    _recommends = recommends;

    notifyListeners();
  }

  _generateNumbers() {
    Set<int> generateNumbers = _numbers.toSet();

    Map<LottoColorType, int> requiredGenerateColorsCount = Map.from(_colors);

    Map<LottoEvenOddType, int> requiredGenerateEvenOddCount =
        Map.from(_evenOdd);

    List<LottoEvenOddType> evenOddTable = List.filled(
        generateNumbers.length, LottoEvenOddType.none,
        growable: true);

    if (requiredGenerateColorsCount[LottoColorType.green] == 5) {
      generateNumbers.addAll(List<int>.generate(5, (i) => 41 + i));
    }

    generateNumbers.forEach((number) {
      LottoColorType color = LottoColor.getLottoNumberColorType(number);
      LottoEvenOddType evenOdd = LottoEvenOdd.getEvenOddType(number);

      requiredGenerateColorsCount[color] =
          requiredGenerateColorsCount[color]! - 1;

      requiredGenerateEvenOddCount[evenOdd] =
          requiredGenerateEvenOddCount[evenOdd]! - 1;
    });

    List<LottoEvenOddType> evenOdds = [];
    requiredGenerateEvenOddCount.forEach((evenOdd, count) {
      for (int i = 0; i < count; i++) {
        evenOdds.add(evenOdd);
      }
    });

    for (int i = 0; evenOddTable.length + evenOdds.length < 6; i++) {
      evenOdds.add(LottoEvenOddType.none);
    }

    evenOddTable.addAll(evenOdds..shuffle());

    requiredGenerateColorsCount.forEach((color, count) {
      if (count > 0) {
        int limitIndex = generateNumbers.length + count;
        while (generateNumbers.length < limitIndex) {
          generateNumbers.add(_generateNumberByColor(
            color,
            evenOdd: evenOddTable[generateNumbers.length],
          ));
        }
      }
    });

    while (generateNumbers.length < 6) {
      generateNumbers
          .add(_generateNumber(evenOdd: evenOddTable[generateNumbers.length]));
    }

    return generateNumbers.toList()..sort();
  }

  _generateNumberByColor(LottoColorType color,
      {LottoEvenOddType evenOdd = LottoEvenOddType.none}) {
    int min = 1;
    int max = 45;

    switch (color) {
      case LottoColorType.yellow:
        min = 1;
        max = 10;
        break;
      case LottoColorType.blue:
        min = 11;
        max = 10;
        break;
      case LottoColorType.red:
        min = 21;
        max = 10;
        break;
      case LottoColorType.gray:
        min = 31;
        max = 10;
        break;
      case LottoColorType.green:
        min = 41;
        max = 5;
        break;
      default:
        min = 1;
        max = 45;
    }

    return _generateNumber(min: min, max: max, evenOdd: evenOdd);
  }

  _generateNumber({
    int min = 1,
    int max = 45,
    LottoEvenOddType evenOdd = LottoEvenOddType.none,
  }) {
    var random = Random();
    int result = random.nextInt(max) + min;

    if (LottoEvenOddType.none != evenOdd) {
      if (_diffEvenOdd(result, evenOdd)) {
        result = _editEvenOddNumber(min, result);
      }
    }

    return result;
  }

  _diffEvenOdd(int num, LottoEvenOddType evenOdd) {
    return (num.isOdd && LottoEvenOddType.even == evenOdd) ||
        (num.isEven && LottoEvenOddType.odd == evenOdd);
  }

  _editEvenOddNumber(int min, int num) {
    return num - 1 < min ? num + 1 : num - 1;
  }
}
