import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      child: Column(
        children: [
          _makeSearchTypeSwitchListTile(),
          _makeSearchValueArea(),
          Expanded(
            child: SingleChildScrollView(
              child: Consumer<HistoryState>(builder: (_, historyState, __) {
                return Container(
                  color: AppColors.backgroundAccent,
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13.0),
                          color: AppColors.backgroundLight,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 10.0,
                              offset: Offset.zero,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AppTextButton(
                              labelIcon: historyState.isMyHistory
                                  ? FontAwesomeIcons.checkCircle
                                  : FontAwesomeIcons.circle,
                              labelText: '나의 히스토리',
                              onPressed: () {
                                historyState.isMyHistory = true;
                              },
                            ),
                            AppTextButton(
                              labelIcon: historyState.isMyHistory
                                  ? FontAwesomeIcons.circle
                                  : FontAwesomeIcons.checkCircle,
                              labelText: '전체 히스토리',
                              onPressed: () {
                                historyState.isMyHistory = false;
                              },
                            ),
                          ],
                        ),
                      ),
                      historyState.isMyHistory
                          ? _makeMyStatInfo(historyState.myHistory)
                          : _makeTotalStatInfo(historyState.drawHistory),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  _makeSearchTypeSwitchListTile() {
    return Consumer<HistoryState>(builder: (_, historyState, __) {
      var isDraw = historyState.searchType == 'draw';
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SwitchListTile(
          title: isDraw ? Text('회차 선택') : Text('전체 회차'),
          value: isDraw,
          onChanged: (value) {
            historyState.setSearchType(value ? 'draw' : 'all');
            historyState.getHistory();
          },
        ),
      );
    });
  }

  _makeSearchValueArea() {
    return Consumer<HistoryState>(
      builder: (_, historyState, __) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
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
          ),
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
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        children: [
          ListTile(
            title: Text(
              '총 당첨금',
              style: TextStyle(fontSize: 25.0),
            ),
            trailing: AppTextButton(
              onPressed: () {
                Get.to(() => HistoryList());
              },
              labelText: '모두보기',
              labelIcon: Icons.navigate_next,
              isIconFirst: false,
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.light,
              child: FaIcon(FontAwesomeIcons.award),
            ),
            title: Row(
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
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.light,
              child: FaIcon(FontAwesomeIcons.percentage),
            ),
            title: Text(
              myHistory.buyCount == 0
                  ? '-'
                  : '${NumberFormat.decimalPercentPattern(decimalDigits: 2).format(myHistory.winRate)}',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
                '(${myHistory.winCount} 게임 당첨 / ${myHistory.buyCount} 게임 구매)'),
          ),
          ListTile(
            title: Text(
              '수익률',
              style: TextStyle(fontSize: 25.0),
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.light,
              child: FaIcon(FontAwesomeIcons.award),
            ),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${NumberFormat.decimalPattern().format(myHistory.profitAmount)} ',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: myHistory.isProfit ? AppColors.up : AppColors.down,
                  ),
                ),
                Text('원'),
              ],
            ),
            subtitle: Text(
              '(${NumberFormat.decimalPattern().format(myHistory.winAmount)} 원 당첨 - ${NumberFormat.decimalPattern().format(myHistory.buyAmount)} 원 구매)',
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.light,
              child: FaIcon(FontAwesomeIcons.percentage),
            ),
            title: Text(
              myHistory.buyAmount == 0
                  ? '-'
                  : '${NumberFormat.decimalPercentPattern(decimalDigits: 2).format(myHistory.profitRate)}',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: myHistory.isProfit ? AppColors.up : AppColors.down,
              ),
            ),
            subtitle: Text(
              '(${NumberFormat.decimalPattern().format(myHistory.winAmount)} 원 당첨 / ${NumberFormat.decimalPattern().format(myHistory.buyAmount)} 원 구매)',
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
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        children: [
          ListTile(
            title: Text(
              '1등 누적 당첨금',
              style: TextStyle(fontSize: 25.0),
            ),
            trailing: AppTextButton(
              onPressed: () {
                Get.to(() => DrawList());
              },
              labelText: '모두보기',
              labelIcon: Icons.navigate_next,
              isIconFirst: false,
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.light,
              child: FaIcon(FontAwesomeIcons.award),
            ),
            title: Row(
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
              ],
            ),
            subtitle: Text(
              '1게임당 평균 ${drawHistory.winCount == 0 ? 0 : (drawHistory.winAmount / drawHistory.winCount / 100000000).round()}억',
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.light,
              child: FaIcon(FontAwesomeIcons.thumbsUp),
            ),
            title: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('최대 1등 상금'),
                    Text(
                      ' ${NumberFormat.decimalPattern().format((drawHistory.maxWinAmount / 100000000).round())}억 ',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('원'),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('최소 1등 상금'),
                    Text(
                      ' ${NumberFormat.decimalPattern().format((drawHistory.minWinAmount / 100000000).round())}억 ',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('원'),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(
              '1등 당첨 확률',
              style: TextStyle(fontSize: 25.0),
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.light,
              child: FaIcon(FontAwesomeIcons.percentage),
            ),
            title: Column(
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
                  '약 ${NumberFormat.decimalPattern().format(drawHistory.buyCount ~/ drawHistory.winCount)} 게임 당 1회 당첨',
                ),
              ],
            ),
            subtitle: Text(
              '${drawHistory.winCount} 게임 당첨 /\n${NumberFormat.decimalPattern().format(drawHistory.buyCount)} 게임 구매',
            ),
          ),
        ],
      ),
    );
  }
}
