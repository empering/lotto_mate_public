import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lotto_mate/pages/stats/color_stats.dart';
import 'package:lotto_mate/pages/stats/even_odd_stats.dart';
import 'package:lotto_mate/pages/stats/number_stats.dart';
import 'package:lotto_mate/pages/stats/series_number_stats.dart';
import 'package:lotto_mate/pages/stats/unpick_number_stats.dart';

class Stats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _makeSubMenus(),
    );
  }

  _makeSubMenus() {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        ListTile(
          title: Text('번호별'),
          leading: Icon(Icons.youtube_searched_for),
          onTap: () {
            Get.to(NumberStats());
          },
        ),
        Divider(),
        ListTile(
          title: Text('색상별'),
          leading: Icon(Icons.color_lens_outlined),
          onTap: () {
            Get.to(ColorStats());
          },
        ),
        Divider(),
        ListTile(
          title: Text('홀짝'),
          leading: Icon(Icons.star_half),
          onTap: () {
            Get.to(EvenOddStats());
          },
        ),
        Divider(),
        ListTile(
          title: Text('연속번호'),
          leading: Icon(Icons.saved_search),
          onTap: () {
            Get.to(SeriesNumberStats());
          },
        ),
        Divider(),
        ListTile(
          title: Text('미출현번호'),
          leading: Icon(Icons.search_off),
          onTap: () {
            Get.to(UnpickNumberStats());
          },
        ),
        Divider(),
      ],
    );
  }
}
