import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/commons/lotto_even_odd.dart';
import 'package:lotto_mate/models/search_filter.dart';
import 'package:lotto_mate/models/stat.dart';
import 'package:lotto_mate/states/stat_state.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';
import 'package:lotto_mate/widgets/app_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:search_choices/search_choices.dart';

class EvenOddStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<StatState>().getStats(statType: StatType.EVEN_ODD);

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
              Divider(),
              _stats(),
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

  _stats() {
    return Consumer<StatState>(builder: (_, statState, __) {
      List<Stat<LottoEvenOddType>> stats = List.from(statState.stats);

      if (stats.length == 0) {
        return Center(child: AppIndicator());
      }

      int totCount = 0;
      stats.forEach((stat) {
        totCount += stat.count;
      });

      if (!statState.isOrderAsc) {
        stats.sort((a, b) => a.count == b.count
            ? a.statType.index - b.statType.index
            : b.count - a.count);
      }

      return Expanded(
        child: ListView.separated(
          controller: statState.listViewController,
          separatorBuilder: (context, index) => Divider(),
          itemCount: stats.length,
          itemBuilder: (context, index) {
            var stat = stats[index];

            return ListTile(
              leading: ClipOval(
                child: Container(
                  alignment: Alignment.center,
                  width: 60,
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FaIcon(
                        stat.statType == LottoEvenOddType.odd
                            ? FontAwesomeIcons.diceThree
                            : FontAwesomeIcons.diceFour,
                        color: AppColors.primary,
                      ),
                      Text(
                        LottoEvenOdd.getEvenOddTypeName(stat.statType),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              trailing:
                  Text('${NumberFormat.decimalPattern().format(stat.count)} 회'),
              title: LinearPercentIndicator(
                animation: true,
                lineHeight: 20.0,
                center: Text(
                  NumberFormat.decimalPercentPattern(decimalDigits: 2)
                      .format(stat.count / totCount),
                  style: TextStyle(color: AppColors.accent),
                ),
                percent: stat.count / totCount,
                progressColor: AppColors.primary,
                backgroundColor: AppColors.sub,
              ),
            );
          },
        ),
      );
    });
  }
}
