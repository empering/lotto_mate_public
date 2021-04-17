import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lotto_mate/commons/app_box_decoration.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/models/draw.dart';
import 'package:lotto_mate/pages/home/draw_view.dart';
import 'package:lotto_mate/states/banner_ad_provider.dart';
import 'package:lotto_mate/states/draw_list_state.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';
import 'package:lotto_mate/widgets/app_indicator.dart';
import 'package:lotto_mate/widgets/lotto_number.dart';
import 'package:provider/provider.dart';

class DrawList extends StatelessWidget {
  final DrawListType type;
  final List<Draw>? drawsFromParent;

  DrawList({this.type = DrawListType.DB, this.drawsFromParent});

  @override
  Widget build(BuildContext context) {
    context.read<DrawListState>().getDraws(
          drawListType: type,
          drawsFromParent: drawsFromParent,
        );

    var adProvider = context.read<BannerAdProvider>();

    return Scaffold(
      appBar: AppAppBar(type == DrawListType.DB ? '회차별 당첨결과' : '추첨결과'),
      body: Container(
        child: _makeDrawListView(adProvider),
      ),
    );
  }

  _makeDrawListView(BannerAdProvider adProvider) {
    return Consumer<DrawListState>(builder: (_, drawListState, __) {
      var draws = drawListState.draws;

      return ListView.separated(
        controller: drawListState.listViewController,
        padding: const EdgeInsets.all(10.0),
        separatorBuilder: (context, index) => Divider(),
        itemCount: draws.length +
            1 +
            drawListState.ads.length +
            (drawListState.ads.length > 0 ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < draws.length + drawListState.ads.length) {
            if (index % 10 == 5) {
              if (drawListState.ads.length <= (index / 10).floor()) {
                drawListState.ads.add(adProvider.newAd);
              }

              var ad = drawListState.ads[(index / 10).floor()];

              return Container(
                alignment: Alignment.center,
                decoration: AppBoxDecoration(
                  color: Colors.white,
                  shdowColor: Colors.transparent,
                ).circular(),
                child: AdWidget(ad: ad),
                height: 72.0,
              );
            }

            var draw = draws[index - (index / 10).round()];
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              decoration: AppBoxDecoration().circular(),
              child: ListTile(
                leading: _makeDrawListLeading(draw.id),
                title: _makeDrawListViewTitle(draw),
                subtitle: _makeDrawListViewSubTitle(draw),
                dense: true,
                isThreeLine: true,
                onTap: () {
                  Get.to(DrawView(draw.id!));
                },
              ),
            );
          }

          if (drawListState.hasMore) {
            return Center(child: AppIndicator());
          } else {
            return Center(child: Text('더 이상 데이터가 없습니다'));
          }
        },
      );
    });
  }

  _makeDrawListLeading(int? id) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$id 회',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  _makeDrawListViewTitle(Draw draw) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ...draw.numbers!
            .take(6)
            .map(
              (n) => LottoNumber(
                number: n,
                fontSize: 16,
              ),
            )
            .toList(),
        Icon(Icons.add),
        LottoNumber(
          number: draw.numbers!.last,
          fontSize: 16,
        ),
      ],
    );
  }

  _makeDrawListViewSubTitle(Draw draw) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '1등 당첨금',
            style: TextStyle(
              fontSize: 16.0,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          VerticalDivider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text('총'),
                  Text(
                    ' ${(draw.totalFirstPrizeAmount! / 100000000).round()}억 ',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '원',
                    style: TextStyle(color: AppColors.primary),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '(${draw.firstPrizewinnerCount}명 / ${(draw.eachFirstPrizeAmount! / 100000000).round()}억)',
                    style: TextStyle(color: AppColors.sub),
                  ),
                ],
              ),
              Text(
                '${draw.drawDate} 추첨',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
