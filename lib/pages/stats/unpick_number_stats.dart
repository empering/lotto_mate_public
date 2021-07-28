import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lotto_mate/commons/app_box_decoration.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/commons/lotto_color.dart';
import 'package:lotto_mate/models/search_filter.dart';
import 'package:lotto_mate/states/stat_state.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';
import 'package:lotto_mate/widgets/app_indicator.dart';
import 'package:lotto_mate/widgets/banner_ad_provider.dart';
import 'package:lotto_mate/widgets/lotto_number.dart';
import 'package:provider/provider.dart';

class UnpickNumberStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var adProvider = context.read<BannerAdProvider>();
    context.read<StatState>().getStats(statType: StatType.UNPICK);

    return Consumer<StatState>(builder: (_, statState, __) {
      SearchFilter searchFilter = statState.searchFilter;
      return Scaffold(
        appBar: AppAppBar('미출현번호'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          child: Column(
            children: [
              _makeSearchValueArea(),
              SwitchListTile(
                title: Text(
                    '보너스 번호 ${searchFilter.isWithBounsNumber ? '포함' : '제외'}'),
                value: searchFilter.isWithBounsNumber,
                onChanged: (value) {
                  searchFilter.isWithBounsNumber = value;

                  statState.notify();
                },
              ),
              Divider(),
              _stats(adProvider),
            ],
          ),
        ),
      );
    });
  }

  _makeSearchValueArea() {
    return Consumer<StatState>(
      builder: (_, statState, __) {
        return Wrap(
          spacing: 10.0,
          children: List<Widget>.generate(
            4,
            (int index) {
              var drawIdDiff = (index + 1) * 5;
              return ChoiceChip(
                label: Text('최근 $drawIdDiff회'),
                selected: drawIdDiff == statState.drawIdDiff,
                selectedColor: AppColors.sub,
                elevation: 10.0,
                onSelected: (bool selected) {
                  statState.changeRecentDrawId(drawIdDiff);
                },
              );
            },
          ).toList(),
        );
      },
    );
  }

  _stats(BannerAdProvider adProvider) {
    return Consumer<StatState>(builder: (_, statState, __) {
      var stats = List.from(statState.stats);

      if (stats.length == 0) {
        return Center(child: AppIndicator());
      }

      if (stats.length == 1 && stats.first < 0) {
        stats = [];
      }

      return Expanded(
        child: ListView.separated(
          controller: statState.listViewController,
          separatorBuilder: (context, index) => Divider(),
          itemCount: 6,
          itemBuilder: (context, index) {
            if (index == 5) {
              var ad = adProvider.newAd;
              var adWidget;
              if (ad is BannerAd) {
                adWidget = AdWidget(ad: ad);
              } else {
                adWidget = ad;
              }

              return Container(
                alignment: Alignment.center,
                decoration: AppBoxDecoration(
                  color: Colors.white,
                  shdowColor: Colors.transparent,
                ).circular(),
                child: adWidget,
                height: 72.0,
              );
            }

            var color = LottoColorType.values[index];
            var numbers = stats.where((number) =>
                LottoColor.getLottoNumberColorType(number) == color);

            return ListTile(
              leading: _makeLeading(color),
              title: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  children: numbers
                      .map((n) => LottoNumber(
                            number: n,
                            fontSize: 17.0,
                          ))
                      .toList(),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  _makeLeading(LottoColorType colorType) {
    return Container(
      width: 85,
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            color: LottoColor.getLottoColor(colorType),
            elevation: 8,
            shape: CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: Container(
              width: 32,
              padding: EdgeInsets.all(6),
            ),
          ),
          Text(
            LottoColor.getLottoColorTypeDesc(colorType),
          ),
        ],
      ),
    );
  }
}
