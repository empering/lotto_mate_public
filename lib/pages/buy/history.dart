import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/models/draw_history.dart';
import 'package:lotto_mate/pages/buy/history_list.dart';
import 'package:lotto_mate/pages/home/draw_list.dart';
import 'package:lotto_mate/states/history_state.dart';
import 'package:lotto_mate/widgets/app_text_button.dart';
import 'package:provider/provider.dart';

class History extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HistoryState()
        ..setSearchDrawValues()
        ..getHistory(),
      child: Consumer<HistoryState>(
        builder: (_, historyState, __) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _makeSearchTypeDropDown(),
                      ),
                      Expanded(
                        flex: 3,
                        child: _makeSearchValueArea(),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '🔥 나의 로또 히스토리',
                              style: TextStyle(fontSize: 20.0),
                            ),
                            AppTextButton(
                              onPressed: () {
                                Get.to(HistoryList());
                              },
                              buttonColor: Colors.transparent,
                              labelColor: AppColors.primary,
                              labelIcon: Icons.navigate_next,
                            )
                          ],
                        ),
                      ),
                      _makeMyStatInfo(historyState.myHistory),
                      Divider(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '🔥 전체 로또 히스토리',
                              style: TextStyle(fontSize: 20.0),
                            ),
                            AppTextButton(
                              onPressed: () {
                                Get.to(DrawList());
                              },
                              buttonColor: Colors.transparent,
                              labelColor: AppColors.primary,
                              labelIcon: Icons.navigate_next,
                            )
                          ],
                        ),
                      ),
                      _makeTotalStatInfo(historyState.drawHistory),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _makeSearchTypeDropDown() {
    return Consumer<HistoryState>(builder: (_, historyState, __) {
      return DropdownButton<String>(
        value: historyState.searchType,
        items: [
          DropdownMenuItem<String>(
            value: 'all',
            child: Text('전체'),
          ),
          // DropdownMenuItem<String>(
          //   value: 'year',
          //   child: Text('년도별'),
          // ),
          // DropdownMenuItem<String>(
          //   value: 'month',
          //   child: Text('월별'),
          // ),
          DropdownMenuItem<String>(
            value: 'draw',
            child: Text('회차별'),
          ),
        ],
        onChanged: (value) {
          historyState.setSearchType(value!);
        },
      );
    });
  }

  _makeSearchValueArea() {
    return Consumer<HistoryState>(
      builder: (_, historyState, __) {
        if (historyState.searchType == 'all') {
          return Container();
        }

        return Row(
          children: [
            SizedBox(width: 20),
            Expanded(
              child: _makeSearchValueDropDown(),
            ),
            SizedBox(width: 10),
            Text('부터'),
            SizedBox(width: 20),
            Expanded(
              child: _makeSearchValueDropDown(isStart: false),
            ),
            SizedBox(width: 10),
            Text('까지'),
          ],
        );
      },
    );
  }

  _makeSearchValues() {
    return ListWheelScrollView(
      itemExtent: 42,
      children: List.generate(950, (index) => Text('${index + 1} 회')).toList(),
    );
  }

  _makeSearchValueDropDown({bool isStart = true}) {
    return Consumer<HistoryState>(
      builder: (_, historyState, __) {
        return DropdownButton<String>(
          isExpanded: true,
          value: isStart
              ? historyState.searchStartValue
              : historyState.searchEndValue,
          items: (isStart
                  ? historyState.searchValues
                  : historyState.searchValues.reversed)
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text('$value 회'),
            );
          }).toList(),
          onChanged: (String? newValue) {
            isStart
                ? historyState.searchStartValue = newValue!
                : historyState.searchEndValue = newValue!;

            historyState.getHistory();
          },
        );
      },
    );
  }

  _makeMyStatInfo(DrawHistory? myHistory) {
    if (myHistory == null) {
      return Center(child: CircularProgressIndicator());
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
                      '${NumberFormat.decimalPercentPattern(decimalDigits: 2).format(myHistory.winCount! / myHistory.buyCount!)}',
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
                      '${NumberFormat.decimalPattern().format(myHistory.winAmount! - myHistory.buyAmount!)} ',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.up,
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
                  '${NumberFormat.decimalPercentPattern(decimalDigits: 2).format(myHistory.winAmount! / myHistory.buyAmount!)}',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.up,
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
      return Center(child: CircularProgressIndicator());
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
                  '${NumberFormat.decimalPattern().format((drawHistory.winAmount! / 100000000).round())}억 ',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('원'),
                SizedBox(width: 10.0),
                Text(
                  '(1게임당 평균 ${drawHistory.winCount == 0 ? 0 : (drawHistory.winAmount! / drawHistory.winCount! / 100000000).round()} 억원)',
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
                      : '${NumberFormat.decimalPercentPattern(decimalDigits: 10).format(drawHistory.winCount! / drawHistory.buyCount!)}',
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
