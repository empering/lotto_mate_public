import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/models/draw_history.dart';
import 'package:lotto_mate/pages/buy/history_list.dart';
import 'package:lotto_mate/pages/home/draw_list.dart';
import 'package:lotto_mate/states/history_state.dart';
import 'package:lotto_mate/widgets/app_indicator.dart';
import 'package:lotto_mate/widgets/app_text_button.dart';
import 'package:provider/provider.dart';
import 'package:search_choices/search_choices.dart';

class History extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<HistoryState>()
      ..setSearchType('all')
      ..getHistory();

    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        child: Column(
          children: [
            _makeSearchTypeSwitchListTile(),
            _makeSearchValueArea(),
            Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '🔥 나의 로또 히스토리',
                              style: TextStyle(fontSize: 20.0),
                            ),
                            AppTextButton(
                              onPressed: () {
                                Get.to(() => HistoryList());
                              },
                              buttonColor: Colors.transparent,
                              labelColor: AppColors.primary,
                              labelIcon: Icons.navigate_next,
                            )
                          ],
                        ),
                      ),
                      Consumer<HistoryState>(builder: (_, historyState, __) {
                        return _makeMyStatInfo(historyState.myHistory);
                      }),
                      Divider(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '🔥 전체 로또 히스토리',
                              style: TextStyle(fontSize: 20.0),
                            ),
                            AppTextButton(
                              onPressed: () {
                                Get.to(() => DrawList());
                              },
                              buttonColor: Colors.transparent,
                              labelColor: AppColors.primary,
                              labelIcon: Icons.navigate_next,
                            )
                          ],
                        ),
                      ),
                      Consumer<HistoryState>(builder: (_, historyState, __) {
                        return _makeTotalStatInfo(historyState.drawHistory);
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _makeSearchTypeSwitchListTile() {
    return Consumer<HistoryState>(builder: (_, historyState, __) {
      var isDraw = historyState.searchType == 'draw';
      return SwitchListTile(
        title: isDraw ? Text('회차 선택') : Text('전체 회차'),
        value: isDraw,
        onChanged: (value) {
          historyState.setSearchType(value ? 'draw' : 'all');
          historyState.getHistory();
        },
      );
    });
  }

  _makeSearchValueArea() {
    return Consumer<HistoryState>(
      builder: (_, historyState, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: _makeSearchChoices(),
            ),
            Text('부터'),
            SizedBox(width: 10),
            Expanded(
              child: _makeSearchChoices(isStart: false),
            ),
            Text('까지'),
          ],
        );
      },
    );
  }

  _makeSearchChoices({bool isStart = true}) {
    return Consumer<HistoryState>(builder: (_, historyState, __) {
      return SearchChoices.single(
        items: (isStart
                ? historyState.searchValues
                : historyState.searchValues.reversed)
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Center(
              child: Text('$value 회'),
            ),
          );
        }).toList(),
        value: isStart
            ? historyState.searchStartValue
            : historyState.searchEndValue,
        searchHint: '회차를 선택하세요',
        onChanged: (newValue) {
          if (newValue == null) {
            newValue = isStart
                ? historyState.searchValues.first
                : historyState.searchValues.last;
          }

          isStart
              ? historyState.searchStartValue = newValue
              : historyState.searchEndValue = newValue;

          historyState.getHistory();
        },
        dialogBox: true,
        isExpanded: true,
        displayClearIcon: false,
        underline: Container(),
        readOnly: historyState.searchType == 'all',
        keyboardType: TextInputType.number,
      );
    });
  }

  _makeMyStatInfo(DrawHistory? myHistory) {
    if (myHistory == null) {
      return Center(child: AppIndicator());
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💰 총 당첨금',
            style: TextStyle(fontSize: 20.0),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${NumberFormat.decimalPattern().format(myHistory.winAmount)} ',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('원'),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      myHistory.buyCount == 0
                          ? '-'
                          : '${NumberFormat.decimalPercentPattern(decimalDigits: 2).format(myHistory.winRate)}',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      '(${myHistory.winCount} 게임 당첨 / ${myHistory.buyCount} 게임 구매)',
                      style: TextStyle(color: AppColors.sub),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(),
          Text(
            '🎰 수익률',
            style: TextStyle(
              fontSize: 20.0,
              // color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${NumberFormat.decimalPattern().format(myHistory.profitAmount)} ',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color:
                            myHistory.isProfit ? AppColors.up : AppColors.down,
                      ),
                    ),
                    Text('원'),
                    SizedBox(width: 10),
                  ],
                ),
                Text(
                  '(${NumberFormat.decimalPattern().format(myHistory.winAmount)} 원 당첨 - ${NumberFormat.decimalPattern().format(myHistory.buyAmount)} 원 구매)',
                  style: TextStyle(color: AppColors.sub),
                ),
                SizedBox(height: 10),
                Text(
                  myHistory.buyAmount == 0
                      ? '-'
                      : '${NumberFormat.decimalPercentPattern(decimalDigits: 2).format(myHistory.profitRate)}',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: myHistory.isProfit ? AppColors.up : AppColors.down,
                  ),
                ),
                Text(
                  '(${NumberFormat.decimalPattern().format(myHistory.winAmount)} 원 당첨 / ${NumberFormat.decimalPattern().format(myHistory.buyAmount)} 원 구매)',
                  style: TextStyle(color: AppColors.sub),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _makeTotalStatInfo(DrawHistory? drawHistory) {
    if (drawHistory == null) {
      return Center(child: AppIndicator());
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💰 1등 누적 당첨금',
            style: TextStyle(fontSize: 20.0),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${NumberFormat.decimalPattern().format((drawHistory.winAmount / 100000000).round())}억 ',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('원'),
                SizedBox(width: 10.0),
                Text(
                  '(1게임당 평균 ${drawHistory.winCount == 0 ? 0 : (drawHistory.winAmount / drawHistory.winCount / 100000000).round()} 억원)',
                  style: TextStyle(color: AppColors.sub),
                ),
              ],
            ),
          ),
          Divider(),
          Text(
            '🎰 1등 당첨 확률',
            style: TextStyle(
              fontSize: 20.0,
              // color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  drawHistory.buyCount == 0
                      ? '-'
                      : '${NumberFormat.decimalPercentPattern(decimalDigits: 10).format(drawHistory.winCount / drawHistory.buyCount)}',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '(${drawHistory.winCount} 게임 당첨 / ${NumberFormat.decimalPattern().format(drawHistory.buyCount)} 게임 구매)',
                  style: TextStyle(color: AppColors.sub),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
