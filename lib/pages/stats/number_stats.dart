import 'package:flutter/material.dart';
import 'package:lotto_mate/states/history_state.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';
import 'package:lotto_mate/widgets/lotto_number.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:search_choices/search_choices.dart';

class NumberStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<HistoryState>()..setSearchType('all');

    return Consumer<HistoryState>(builder: (_, historyState, __) {
      var isDraw = historyState.searchType == 'draw';
      return Scaffold(
        appBar: AppAppBar('번호별'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          child: Column(
            children: [
              SwitchListTile(
                title: Text('보너스 번호 제외'),
                value: false,
                onChanged: (value) {
                  print(value);
                },
              ),
              SwitchListTile(
                title: isDraw ? Text('회차 선택') : Text('전체 회차'),
                value: isDraw,
                onChanged: (value) {
                  historyState.setSearchType(value ? 'draw' : 'all');
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

  _stats() {
    var list = List.generate(20, (index) => index);
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (context, index) => Divider(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: LottoNumber(number: index),
            trailing: Text('101회 당첨'),
            title: LinearPercentIndicator(
              animation: true,
              lineHeight: 20.0,
              percent: (index * 5) / 100,
              progressColor: Colors.blue,
            ),
          );
        },
      ),
    );
  }
}
