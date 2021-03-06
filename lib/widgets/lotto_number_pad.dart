import 'package:flutter/material.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/widgets/lotto_number.dart';

class LottoNumberPad extends StatelessWidget {
  final ValueSetter<int>? numberPicked;
  final double fontSize;

  LottoNumberPad({
    required ValueChanged<int?>? this.numberPicked,
    this.fontSize = 17.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (this.fontSize + 20) * 6,
      padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
      // margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.primary,
        ),
        borderRadius: BorderRadius.circular(10),
        color: AppColors.accent.withOpacity(0.3),
      ),
      child: GridView.count(
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        crossAxisCount: 10,
        children: _makeLottoNumbers(),
      ),
    );
  }

  _makeLottoNumbers() {
    return List<Widget>.generate(
      45,
      (index) => LottoNumber(
        number: index + 1,
        fontSize: fontSize,
        numberPicked: (int number) {
          this.numberPicked!(number);
        },
      ),
    );
  }
}
