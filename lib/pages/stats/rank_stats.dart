import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/models/search_filter.dart';
import 'package:lotto_mate/states/stat_state.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';
import 'package:lotto_mate/widgets/app_indicator.dart';
import 'package:lotto_mate/widgets/banner_ad_provider.dart';
import 'package:provider/provider.dart';
import 'package:search_choices/search_choices.dart';

class RankStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var adProvider = context.read<BannerAdProvider>();
    context.read<StatState>().getStats(statType: StatType.RANK);

    return Consumer<StatState>(builder: (_, statState, __) {
      SearchFilter searchFilter = statState.searchFilter;
      return Scaffold(
        appBar: AppAppBar('등수별 통계'),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              child: SwitchListTile(
                title: searchFilter.isAll ? Text('전체 회차') : Text('회차 선택'),
                subtitle: _makeSearchValueArea(),
                value: searchFilter.isAll,
                onChanged: (value) {
                  searchFilter
                      .setSearchType(value ? SearchType.ALL : SearchType.DRAWS);

                  statState.notify();
                },
              ),
            ),
            _stats(adProvider),
            Consumer<BannerAdProvider>(
              builder: (_, bannerAd, __) {
                var ad = bannerAd.newAd;
                var adWidget;
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

      // stats.add(adProvider.newAd);

      return Expanded(
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
          decoration: BoxDecoration(
            color: AppColors.backgroundAccent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(width: 10),
                  FaIcon(FontAwesomeIcons.infoCircle),
                  SizedBox(width: 10),
                  Text(
                    '총 게임 수',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(width: 20),
                  Text(
                      '${NumberFormat.decimalPattern().format(stats[0]['sellCount'])} 회 도전'),
                ],
              ),
              SizedBox(height: 10.0),
              _makeTable(stats),
            ],
          ),
        ),
      );
    });
  }

  _makeTable(List stats) {
    return Table(
      border: TableBorder.all(color: Colors.grey),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(40),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
        3: FlexColumnWidth(),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(color: AppColors.backgroundLight),
          children: [
            _tableCell('순위', style: TextStyle(fontWeight: FontWeight.bold)),
            _tableCell('당첨수', style: TextStyle(fontWeight: FontWeight.bold)),
            _tableCell('확률', style: TextStyle(fontWeight: FontWeight.bold)),
            _tableCell('실제확률', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        ...stats
            .map((stat) => TableRow(children: _tableRowChildren(stat)))
            .toList(),
      ],
    );
  }

  _tableCell(String value, {TextStyle? style, TextAlign? align}) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          value,
          style: style?.copyWith(fontSize: 14.0) ?? TextStyle(fontSize: 14.0),
          textAlign: align ?? TextAlign.center,
        ),
      ),
    );
  }

  _tableRowChildren(stat) {
    return <Widget>[
      _tableCell('${stat['rank']}등'),
      _tableCell(
        '${NumberFormat.decimalPattern().format(stat['winnerCount'])}',
        align: TextAlign.right,
      ),
      _tableCell(
        '1 / ${_getBaseRankRate(stat['rank'])}',
        align: TextAlign.right,
      ),
      _tableCell(
        '1 / ${NumberFormat.decimalPattern().format(stat['sellCount'] ~/ stat['winnerCount'])}',
        align: TextAlign.right,
      ),
    ];
  }

  _getBaseRankRate(num rank) {
    switch (rank) {
      case 1:
        return '8,145,060';
      case 2:
        return '1,357,510';
      case 3:
        return '35,724';
      case 4:
        return '733';
      case 5:
        return '45';
      default:
        return '-';
    }
  }
}
