import 'package:flutter/material.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/commons/lotto_color.dart';

class LottoNumber extends StatelessWidget {
  final int? number;
  final double fontSize;
  final bool isFixedNumber;
  final List<int?>? winNumbers;
  final ValueSetter<int>? numberPicked;

  LottoNumber({
    this.number,
    this.winNumbers,
    this.isFixedNumber = false,
    this.fontSize = 20,
    this.numberPicked,
  });

  @override
  Widget build(BuildContext context) {
    if (this.numberPicked != null) {
      return GestureDetector(
        onTap: () {
          this.numberPicked!(this.number!);
        },
        child: _makeNumber(),
      );
    } else {
      return _makeNumber();
    }
  }

  Color _getColor() {
    if (number == null) {
      return LottoColor.none;
    }

    if (winNumbers != null && winNumbers!.length == 7) {
      var indexOfNumber = winNumbers!.indexOf(number);
      if (indexOfNumber < 0 || indexOfNumber == 6) {
        return LottoColor.notMatched;
      }
    }

    return LottoColor.getLottoNumberColor(number!);
  }

  _makeNumber() {
    return this.isFixedNumber ? _makeStackNumberWidget() : _makeNumberWidget();
  }

  _makeStackNumberWidget() {
    return Stack(
      alignment: Alignment.bottomRight,
      clipBehavior: Clip.none,
      children: [
        _makeNumberWidget(),
        Text(
          'Fix',
          style: TextStyle(
            color: AppColors.up,
            fontWeight: FontWeight.bold,
            fontSize: this.fontSize * 0.6,
            backgroundColor: Colors.white38,
          ),
        ),
      ],
    );
  }

  _makeNumberWidget() {
    return Material(
      color: _getColor(),
      child: Container(
        width: this.fontSize * 2,
        padding: EdgeInsets.all(this.fontSize / 5),
        child: Center(
          child: Text(
            number == null ? '' : '$number',
            style: TextStyle(color: AppColors.light, fontSize: this.fontSize),
          ),
        ),
      ),
      elevation: number != null ? this.fontSize / 2 : 0.0,
      shape: CircleBorder(),
      clipBehavior: Clip.antiAlias,
    );
  }
}
