import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/pages/home/draw_info.dart';
import 'package:lotto_mate/pages/home/draw_list.dart';
import 'package:lotto_mate/pages/home/draw_view.dart';
import 'package:lotto_mate/states/app_config_state.dart';
import 'package:lotto_mate/states/banner_ad_provider.dart';
import 'package:lotto_mate/states/home_state.dart';
import 'package:lotto_mate/widgets/app_indicator.dart';
import 'package:lotto_mate/widgets/app_text_button.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<HomeState>().getDrawById();

    return Column(
      children: [
        Expanded(
          child: Consumer<HomeState>(
            builder: (_, drawState, __) {
              return drawState.draw == null
                  ? Center(child: AppIndicator())
                  : Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: _makeLottoDrawInfo(context, drawState.draw),
                        ),
                      ),
                    );
            },
          ),
        ),
        Consumer<BannerAdProvider>(
          builder: (_, bannerAd, __) {
            var ad = bannerAd.ad;
            var adWidget;
            print(ad);
            if (ad is BannerAd) {
              adWidget = AdWidget(ad: ad);
            } else {
              adWidget = ad;
            }
            return AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInToLinear,
              alignment: Alignment.center,
              child: adWidget,
              height: 65,
              color: Colors.white,
            );
          },
        ),
      ],
    );
  }

  _makeLottoDrawInfo(BuildContext context, draw) {
    return <Widget>[
      DrawInfo(draw),
      Divider(color: Colors.transparent),
      _makeWinnerInfo(context, draw),
    ];
  }

  _makeWinnerInfo(BuildContext context, draw) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      color: AppColors.backgroundAccent,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0, 10.0),
            child: Wrap(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.light,
                    radius: 20,
                    child: FaIcon(
                      FontAwesomeIcons.trophy,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    '1등 당첨금',
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          fontSize: 20,
                        ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...draw.totalSellAmount == 0
                          ? [
                              Text(
                                '당첨금 집계 중입니다',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.copyWith(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ]
                          : [
                              Text(
                                '${(draw.totalFirstPrizeAmount / 100000000).round()}억 원',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.copyWith(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                '(${(draw.eachFirstPrizeAmount / 100000000).round()}억 원 씩 총 ${draw.firstPrizewinnerCount}명)',
                                style: TextStyle(color: AppColors.sub),
                              ),
                            ],
                    ],
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
                    radius: 20,
                    child: FaIcon(
                      FontAwesomeIcons.wonSign,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    '총 판매금액',
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          fontSize: 20,
                        ),
                  ),
                  subtitle: Text(
                    draw.totalSellAmount == 0
                        ? '-'
                        : '${NumberFormat.decimalPattern().format(draw.totalSellAmount ~/ 100000000)}억 원',
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ),
          _makeButtons(context),
        ],
      ),
    );
  }

  _makeButtons(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13.0),
        color: AppColors.backgroundLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 10.0,
            offset: Offset.zero,
          ),
        ],
      ),
      child: ListTile(
        leading: AppTextButton(
          onPressed: () async {
            await context.read<HomeState>().getPrevDraw();
            context.read<AppConfigState>().requestNotifyPermission();
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
          onPressed: () async {
            await context.read<AppConfigState>().requestNotifyPermission();
            Get.to(() => DrawList());
          },
        ),
      ),
    );
  }
}
