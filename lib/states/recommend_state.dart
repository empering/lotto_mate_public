import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:lotto_mate/commons/lotto_color.dart';

enum LottoEvenOdd { even, odd }

class RecommendState with ChangeNotifier {
  final int numbersLimitSize = 5;

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

  List<int> get numbers => _numbers.toList()..sort();

  Map<LottoColors, int> get colors => _colors;

  Map<LottoEvenOdd, int> get evenOdd => _evenOdd;

  bool get numberAddable => _numbers.length < numbersLimitSize;

  bool isContains(int number) {
    return _numbers.contains(number);
  }

  addNumber(int number) {
    _numbers.add(number);

    notifyListeners();
  }

  removeNumber(int number) {
    _numbers.remove(number);

    notifyListeners();
  }

  clearNumbers() {
    _numbers.clear();

    notifyListeners();
  }

  setColorCount(LottoColors color, int count) {
    _colors[color] = count;

    notifyListeners();
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
