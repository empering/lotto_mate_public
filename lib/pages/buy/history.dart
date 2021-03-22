import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/models/draw_history.dart';
import 'package:lotto_mate/pages/buy/history_list.dart';
import 'package:lotto_mate/pages/home/draw_list.dart';
import 'package:lotto_mate/states/history_state.dart';
import 'package:lotto_mate/widgets/app_flat_button.dart';
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
                Row(
                  children: [
                    Container(child: _makeMyStatInfo(historyState.myHistory)),
                  ],
                ),
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
                Row(
                  children: [
                    Expanded(
                        child: _makeTotalStatInfo(historyState.drawHistory)),
                  ],
                ),
                Divider(height: 20.0),
              ],
            ),
          );
        },
      ),
    );
  }

  _makeSearchTypeDropDown() {
    return Consumer<HistoryState>(builder: (_, historyState, __) {
      return DropdownButtonFormField<String>(
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
        onSaved: (newValue) {
          print('onSaved');
          print(newValue);
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

  _makeSearchValueDropDown({bool isStart = true}) {
    return Consumer<HistoryState>(
      builder: (_, historyState, __) {
        return DropdownButtonFormField<String>(
          value: isStart
              ? historyState.searchStartValue
              : historyState.searchEndValue,
          items: historyState.searchValues
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
          onSaved: (String? value) {},
        );
      },
    );
  }

  _makeMyStatInfo(DrawHistory? myHistory) {
    if (myHistory == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 5.0, 0, 5.0),
      decoration: BoxDecoration(
          // color: AppColors.primary,
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💰 총 당첨금',
            style: TextStyle(
              fontSize: 20,
              // color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${NumberFormat.decimalPattern().format(myHistory.winAmount)} 원',
                  style: TextStyle(
                    fontSize: 22,
                    // color: Colors.white,
                  ),
                ),
                Text(
                  '(총 ${NumberFormat.decimalPattern().format(myHistory.winCount)} 회 당첨)',
                  style: TextStyle(
                    fontSize: 15,
                    // color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
          Text(
            '🎰 수익률',
            style: TextStyle(
              fontSize: 20,
              // color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${NumberFormat.decimalPattern().format(myHistory.winAmount! - myHistory.buyAmount!)} 원',
                style: TextStyle(
                  fontSize: 22,
                  // color: Colors.white,
                ),
              ),
              SizedBox(width: 10),
              Text(
                '(${NumberFormat.decimalPercentPattern(decimalDigits: 2).format(myHistory.winAmount! / myHistory.buyAmount!)})',
                style: TextStyle(
                  fontSize: 22,
                  // color: Colors.white,
                ),
              ),
            ],
          ),
          Text(
            '(${NumberFormat.decimalPattern().format(myHistory.buyAmount)} 원 구매)',
            style: TextStyle(
              fontSize: 15,
              // color: Colors.white,
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
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
          // color: AppColors.primary,
          ),
      child: Column(
        children: [
          Text(
            '💰 1등 누적 당첨금',
            style: TextStyle(
              fontSize: 20,
              // color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '${NumberFormat.decimalPattern().format(drawHistory.winAmount! ~/ 100000000)} 억원',
            style: TextStyle(
              fontSize: 22,
              // color: Colors.white,
            ),
          ),
          Text(
            '(1명당 평균 ${drawHistory.winAmount! / drawHistory.winCount! ~/ 100000000} 억원)',
            style: TextStyle(
              fontSize: 15,
              // color: Colors.white,
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
          Text(
            '🎰 1등 당첨 확률',
            style: TextStyle(
              fontSize: 20,
              // color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '${NumberFormat.decimalPercentPattern(decimalDigits: 10).format(drawHistory.winCount! / drawHistory.buyCount!)}',
            style: TextStyle(
              fontSize: 22,
              // color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
