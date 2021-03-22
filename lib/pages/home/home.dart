import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/pages/home/draw_info.dart';
import 'package:lotto_mate/pages/home/draw_list.dart';
import 'package:lotto_mate/pages/home/draw_view.dart';
import 'package:lotto_mate/states/draw_state.dart';
import 'package:lotto_mate/widgets/app_flat_button.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DrawState()..getDrawById(),
      child: Container(
        padding: const EdgeInsets.only(bottom: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Consumer<DrawState>(
                builder: (context, drawState, child) => Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _makeLottoDrawInfo(context, drawState.draw),
                  ),
                ),
              ),
            ),
            Divider(),
            Container(
              height: 150,
              color: AppColors.accentLight,
            ),
          ],
        ),
      ),
    );
  }

  _makeLottoDrawInfo(BuildContext context, draw) {
    if (draw == null) {
      return [CircularProgressIndicator()];
    }

    return <Widget>[
      DrawInfo(draw),
      Container(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        decoration: BoxDecoration(
          color: AppColors.primary,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppTextButton(
                  onPressed: () {
                    context.read<DrawState>().getPrevDraw();
                  },
                  labelIcon: Icons.navigate_before,
                ),
                Column(
                  children: [
                    Text(
                      '1등 총 당첨금',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${draw.totalFirstPrizeAmount ~/ 100000000}억원',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 15),
                        Text(
                          '(${draw.firstPrizewinnerCount}명 / ${draw.eachFirstPrizeAmount ~/ 100000000}억)',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      '총 판매금액 : ${NumberFormat.decimalPattern().format(draw.totalSellAmount ~/ 100000000)}억원',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                AppTextButton(
                  onPressed: () {
                    context.read<DrawState>().getNextDraw();
                  },
                  labelIcon: Icons.navigate_next,
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AppTextButton(
                  buttonColor: Colors.white54,
                  labelColor: AppColors.primaryDark,
                  labelText: '회차별 당첨결과',
                  labelIcon: Icons.fact_check_outlined,
                  onPressed: () {
                    Get.to(DrawList());
                  },
                ),
                AppTextButton(
                  buttonColor: Colors.white54,
                  labelColor: AppColors.primaryDark,
                  labelText: '당첨결과 상세',
                  labelIcon: Icons.saved_search,
                  onPressed: () {
                    Get.to(DrawView(draw.id));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ];
  }
}
