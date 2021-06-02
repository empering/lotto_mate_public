import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

    return LottoColor.getLottoNumberColor(number!);
  }

  _isNotMatched() {
    if (number != null && winNumbers != null && winNumbers!.length == 7) {
      return !winNumbers!.take(6).contains(number);
    }

    return false;
  }

  _makeNumber() {
    if (this.isFixedNumber) {
      return _makeFixedNumberWidget();
    }

    if (_isNotMatched()) {
      return _makeNotMatchedNumberWidget();
    }

    return _makeNumberWidget();
  }

  _makeFixedNumberWidget() {
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

  _makeNotMatchedNumberWidget() {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        _makeNumberWidget(),
        FaIcon(
          FontAwesomeIcons.slash,
          color: Colors.black.withOpacity(0.4),
          size: this.fontSize * 1.3,
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
