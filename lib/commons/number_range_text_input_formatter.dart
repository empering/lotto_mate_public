import 'package:flutter/services.dart';

class NumberRangeTextInputFormatter extends TextInputFormatter {

  final int _limit;

  NumberRangeTextInputFormatter(this._limit);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text == '') {
      return TextEditingValue();
    } else if (int.parse(newValue.text) < 1) {
      return TextEditingValue().copyWith(text: '1');
    }

    return int.parse(newValue.text) > _limit ? oldValue : newValue;
  }

}