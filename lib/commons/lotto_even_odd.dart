enum LottoEvenOddType { even, odd }

class LottoEvenOdd {
  static LottoEvenOddType getEvenOddType(int number) {
    return number.isOdd ? LottoEvenOddType.odd : LottoEvenOddType.even;
  }

  static String getEvenOddTypeName(LottoEvenOddType evenOddType) {
    return evenOddType == LottoEvenOddType.odd ? '홀' : '짝';
  }
}
