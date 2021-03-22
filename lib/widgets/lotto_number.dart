import 'package:flutter/material.dart';

class LottoNumber extends StatelessWidget {
  final int? number;
  final double fontSize;
  final List<int?>? winNumbers;

  LottoNumber({this.number, this.winNumbers, this.fontSize = 20});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.fontSize * 2,
      child: CircleAvatar(
        backgroundColor: _getColor(),
        child: Text(
          number == null ? '' : '$number',
          style: TextStyle(
            color: Colors.white,
            fontSize: this.fontSize
          ),
        ),
      ),
    );
  }

  Color _getColor() {
    if (number == null) {
      return Colors.white24;
    }

    if (winNumbers != null && winNumbers!.length == 7) {
      var indexOfNumber = winNumbers!.indexOf(number);
      if (indexOfNumber < 0 || indexOfNumber == 6) {
        return Colors.grey.withOpacity(0.35);
      }
    }

    switch ((number! - 1) ~/ 10) {
      case 0:
        return Colors.amber;
      case 1:
        return Colors.cyan;
      case 2:
        return Colors.pinkAccent;
      case 3:
        return Colors.blueGrey;
      case 4:
        return Colors.lime;
    }

    return Colors.amber;
  }

}
