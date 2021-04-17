import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lotto_mate/commons/app_box_decoration.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/pages/home/draw_info.dart';
import 'package:lotto_mate/pages/home/draw_list.dart';
import 'package:lotto_mate/pages/home/draw_view.dart';
import 'package:lotto_mate/states/home_state.dart';
import 'package:lotto_mate/widgets/app_indicator.dart';
import 'package:lotto_mate/widgets/app_text_button.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<HomeState>().getDrawById();

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Consumer<HomeState>(
        builder: (_, drawState, __) {
          return drawState.draw == null
              ? Center(child: AppIndicator())
              : Column(children: _makeLottoDrawInfo(context, drawState.draw));
        },
      ),
    );
  }

  _makeLottoDrawInfo(BuildContext context, draw) {
    return [
      DrawInfo(draw),
      Expanded(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              decoration: AppBoxDecoration(color: AppColors.backgroundAccent)
                  .circular(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 20.0,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppTextButton(
                          onPressed: () {
                            context.read<HomeState>().getPrevDraw();
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
                            SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('총 판매금액'),
                                Text(
                                  ' ${NumberFormat.decimalPattern().format(draw.totalSellAmount ~/ 100000000)}억 ',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('원'),
                              ],
                            ),
                          ],
                        ),
                        AppTextButton(
                          onPressed: () {
                            context.read<HomeState>().getNextDraw();
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
                            Get.to(() => DrawList());
                          },
                        ),
                        AppTextButton(
                          buttonColor: AppColors.light,
                          labelText: '당첨결과 상세',
                          labelIcon: Icons.saved_search,
                          onPressed: () {
                            Get.to(() => DrawView(draw.id));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ];
  }
}
