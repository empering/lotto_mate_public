import 'package:flutter/material.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/states/buy_state.dart';
import 'package:lotto_mate/widgets/lotto_number.dart';
import 'package:provider/provider.dart';

class LottoNumberPad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var buyState = Provider.of<BuyState>(context);

    return Container(
      height: 200,
      padding: EdgeInsets.fromLTRB(5, 15, 5, 0),
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.primary,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
        color: AppColors.primary.withOpacity(0.3),
      ),
      child: GridView.count(
        mainAxisSpacing: 5,
        crossAxisSpacing: 10,
        crossAxisCount: 10,
        children: _makeLottoNumbers(buyState),
      ),
    );
  }

  _makeLottoNumbers(BuyState buyState) {
    return List<Widget>.generate(
      45,
      (index) => GestureDetector(
        onTap: () {
          buyState.pickNumber(index + 1);
        },
        child: LottoNumber(number: index + 1, fontSize: 17,),
      ),
    );
  }
}
