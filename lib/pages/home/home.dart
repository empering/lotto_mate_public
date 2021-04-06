import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/pages/home/draw_info.dart';
import 'package:lotto_mate/pages/home/draw_list.dart';
import 'package:lotto_mate/pages/home/draw_view.dart';
import 'package:lotto_mate/states/draw_state.dart';
import 'package:lotto_mate/widgets/app_indicator.dart';
import 'package:lotto_mate/widgets/app_text_button.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Expanded(
            child: Consumer<DrawState>(
              builder: (context, drawState, child) => Container(
                child: Column(
                  children: _makeLottoDrawInfo(context, drawState.draw),
                ),
              ),
            ),
          ),
          Divider(),
          Container(
            height: 150,
            color: AppColors.backgroundAccent,
          ),
        ],
      ),
    );
  }

  _makeLottoDrawInfo(BuildContext context, draw) {
    if (draw == null) {
      return [AppIndicator()];
    }

    return <Widget>[
      DrawInfo(draw),
      Material(
        elevation: 3.0,
        color: AppColors.backgroundAccent,
        borderRadius: BorderRadius.circular(30.0),
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
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
                        '🥇 1등 당첨금',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${(draw.totalFirstPrizeAmount / 100000000).round()}억 ',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('원'),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${(draw.eachFirstPrizeAmount / 100000000).round()}억 ',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('원 씩 총'),
                          Text(
                            ' ${draw.firstPrizewinnerCount}',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('명 지급'),
                        ],
                      ),
                      /*SizedBox(height: 20),
                      Text(
                        '총 판매금액',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${NumberFormat.decimalPattern().format(draw.totalSellAmount ~/ 100000000)}억 ',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('원'),
                        ],
                      ),*/
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
              Divider(color: AppColors.light),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AppTextButton(
                    buttonColor: AppColors.light,
                    labelText: '회차별 당첨결과',
                    labelIcon: Icons.fact_check_outlined,
                    onPressed: () {
                      Get.to(DrawList());
                    },
                  ),
                  AppTextButton(
                    buttonColor: AppColors.light,
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
      ),
    ];
  }
}
