import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/pages/home/draw_info.dart';
import 'package:lotto_mate/pages/home/draw_list.dart';
import 'package:lotto_mate/pages/home/draw_view.dart';
import 'package:lotto_mate/states/app_config_state.dart';
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
    return <Widget>[
      DrawInfo(draw),
      _makeWinnerInfo(context, draw),
    ];
  }

  _makeWinnerInfo(BuildContext context, draw) {
    return Material(
      elevation: 10.0,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0, 10.0),
            color: AppColors.backgroundAccent,
            child: Wrap(
              children: [
                ListTile(
                  title: Text(
                    '1등 당첨금',
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  trailing: AppTextButton(
                    labelText: '당첨결과 상세',
                    labelIcon: Icons.navigate_next,
                    isIconFirst: false,
                    onPressed: () {
                      Get.to(() => DrawView(draw.id));
                    },
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.light,
                    child: FaIcon(FontAwesomeIcons.trophy),
                  ),
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${(draw.totalFirstPrizeAmount / 100000000).round()}억원',
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        '(${(draw.eachFirstPrizeAmount / 100000000).round()}억 원 씩 총 ${draw.firstPrizewinnerCount}명)',
                        style: TextStyle(color: AppColors.sub),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(
                    '총 판매금액',
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.light,
                    child: FaIcon(FontAwesomeIcons.wonSign),
                  ),
                  title: Text(
                    '${NumberFormat.decimalPattern().format(draw.totalSellAmount ~/ 100000000)}억 원',
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListTile(
              leading: AppTextButton(
                onPressed: () {
                  context.read<HomeState>().getPrevDraw();
                },
                labelText: '이전',
                labelIcon: Icons.navigate_before,
              ),
              trailing: AppTextButton(
                onPressed: () async {
                  await context.read<HomeState>().getNextDraw();
                  context.read<AppConfigState>().requestNotifyPermission();
                },
                labelText: '다음',
                labelIcon: Icons.navigate_next,
                isIconFirst: false,
              ),
              title: AppTextButton(
                labelText: '모든회차 보기',
                labelIcon: Icons.fact_check_outlined,
                onPressed: () {
                  Get.to(() => DrawList());
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
