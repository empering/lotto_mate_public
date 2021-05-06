import 'package:flutter/material.dart';
import 'package:flutter_coupang_ad/flutter_coupang_ad.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/pages/stats/color_stats.dart';
import 'package:lotto_mate/pages/stats/even_odd_stats.dart';
import 'package:lotto_mate/pages/stats/number_stats.dart';
import 'package:lotto_mate/pages/stats/rank_stats.dart';
import 'package:lotto_mate/pages/stats/series_number_stats.dart';
import 'package:lotto_mate/pages/stats/unpick_number_stats.dart';

class Stats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Expanded(
            child: _makeSubMenus(),
          ),
          CoupangAdView(
            CoupangAdConfig(
              adId: '477283',
              // width: MediaQuery.of(context).copyWith().size.width,
              height: 65,
            ),
          )
        ],
      ),
    );
  }

  _makeSubMenus() {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        ListTile(
          title: Text('번호별'),
          leading: FaIcon(FontAwesomeIcons.dice),
          onTap: () {
            Get.to(() => NumberStats());
          },
        ),
        Divider(),
        ListTile(
          title: Text('색상별'),
          leading: FaIcon(FontAwesomeIcons.palette),
          onTap: () {
            Get.to(() => ColorStats());
          },
        ),
        Divider(),
        ListTile(
          title: Text('홀짝'),
          leading: FaIcon(FontAwesomeIcons.adjust),
          onTap: () {
            Get.to(() => EvenOddStats());
          },
        ),
        Divider(),
        ListTile(
          title: Text('연속번호'),
          leading: FaIcon(FontAwesomeIcons.listOl),
          onTap: () {
            Get.to(() => SeriesNumberStats());
          },
        ),
        Divider(),
        ListTile(
          title: Text('미출현번호'),
          leading: FaIcon(FontAwesomeIcons.ban),
          onTap: () {
            Get.to(() => UnpickNumberStats());
          },
        ),
        Divider(),
        ListTile(
          title: Text('등수별 당첨확률'),
          subtitle: Text(
            '새로운기능!',
            style: TextStyle(color: AppColors.up),
          ),
          leading: FaIcon(FontAwesomeIcons.percentage),
          onTap: () {
            Get.to(() => RankStats());
          },
        ),
        Divider(),
      ],
    );
  }
}
