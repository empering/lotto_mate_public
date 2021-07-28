import 'package:flutter/material.dart';
import 'package:flutter_coupang_ad/flutter_coupang_ad.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:lotto_mate/commons/app_box_decoration.dart';
import 'package:lotto_mate/commons/lotto_color.dart';
import 'package:lotto_mate/models/search_filter.dart';
import 'package:lotto_mate/states/stat_state.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';
import 'package:lotto_mate/widgets/app_indicator.dart';
import 'package:lotto_mate/widgets/banner_ad_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:search_choices/search_choices.dart';

class ColorStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var adProvider = context.read<BannerAdProvider>();
    context.read<StatState>().getStats(statType: StatType.COLOR);

    return Consumer<StatState>(builder: (_, statState, __) {
      SearchFilter searchFilter = statState.searchFilter;
      return Scaffold(
        appBar: AppAppBar('색상별'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          child: Column(
            children: [
              SwitchListTile(
                title: Text(
                    '보너스 번호 ${searchFilter.isWithBounsNumber ? '포함' : '제외'}'),
                value: searchFilter.isWithBounsNumber,
                onChanged: (value) {
                  searchFilter.isWithBounsNumber = value;

                  statState.notify();
                },
              ),
              SwitchListTile(
                title: searchFilter.isAll ? Text('전체 회차') : Text('회차 선택'),
                value: searchFilter.isAll,
                onChanged: (value) {
                  searchFilter
                      .setSearchType(value ? SearchType.ALL : SearchType.DRAWS);

                  statState.notify();
                },
              ),
              _makeSearchValueArea(),
              SwitchListTile(
                title: searchFilter.isAsc ? Text('색상 순서') : Text('당첨 횟수 순서'),
                value: searchFilter.isAsc,
                onChanged: (value) {
                  searchFilter.setOrder(value ? Order.ASC : Order.DESC);

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: _makeSearchChoices(),
        ),
        Text('부터'),
        VerticalDivider(),
        Expanded(
          child: _makeSearchChoices(isStart: false),
        ),
        Text('까지'),
      ],
    );
  }

  _makeSearchChoices({bool isStart = true}) {
    return Consumer<StatState>(builder: (_, statState, __) {
      SearchFilter searchFilter = statState.searchFilter;
      return SearchChoices.single(
        items: (isStart
                ? searchFilter.searchValues
                : searchFilter.searchValues.reversed)
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Center(
              child: Text('$value 회'),
            ),
          );
        }).toList(),
        value: isStart
            ? searchFilter.searchStartValue
            : searchFilter.searchEndValue,
        searchHint: '회차를 선택하세요',
        onChanged: (newValue) {
          if (newValue == null) {
            newValue = isStart
                ? searchFilter.searchValues.first
                : searchFilter.searchValues.last;
          }

          isStart
              ? searchFilter.searchStartValue = newValue
              : searchFilter.searchEndValue = newValue;

          statState.notify();
        },
        dialogBox: true,
        isExpanded: true,
        displayClearIcon: false,
        underline: Container(),
        readOnly: searchFilter.isAll,
        keyboardType: TextInputType.number,
      );
    });
  }

  _stats(BannerAdProvider adProvider) {
    return Consumer<StatState>(builder: (_, statState, __) {
      var stats = List.from(statState.stats);

      if (stats.length == 0) {
        return Center(child: AppIndicator());
      }

      int maxCount = stats.fold(0, (p, s) => p > s.count ? p : s.count);

      if (!statState.isOrderAsc) {
        stats.sort((a, b) => a.count == b.count
            ? a.statType.index - b.statType.index
            : b.count - a.count);
      }

      stats.add(adProvider.newAd);

      return Expanded(
        child: ListView.separated(
          controller: statState.listViewController,
          separatorBuilder: (context, index) => Divider(),
          itemCount: stats.length,
          itemBuilder: (context, index) {
            var stat = stats[index];

            if (stat is BannerAd || stat is CoupangAdView) {
              var ad = stat;
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

            var color = stat.statType;

            return ListTile(
              leading: _makeLeading(color),
              trailing:
                  Text('${NumberFormat.decimalPattern().format(stat.count)} 회'),
              title: LinearPercentIndicator(
                animation: true,
                lineHeight: 20.0,
                center: Text(
                  NumberFormat.decimalPercentPattern(decimalDigits: 2)
                      .format(stat.count / maxCount),
                ),
                percent: stat.count / maxCount,
                progressColor: LottoColor.getLottoColor(stat.statType),
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
