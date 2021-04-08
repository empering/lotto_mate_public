import 'package:flutter/material.dart';
import 'package:lotto_mate/states/search_filter_state.dart';
import 'package:lotto_mate/states/stat_state.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';
import 'package:lotto_mate/widgets/app_indicator.dart';
import 'package:lotto_mate/widgets/lotto_number.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:search_choices/search_choices.dart';

class NumberStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<StatState>().getData();

    return Consumer<SearchFilterState>(builder: (_, searchFilterState, __) {
      var isDraw = searchFilterState.isDraw;
      return Scaffold(
        appBar: AppAppBar('번호별'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          child: Column(
            children: [
              SwitchListTile(
                title: Text(
                    '보너스 번호 ${searchFilterState.isWithBounsNumber ? '포함' : '제외'}'),
                value: searchFilterState.isWithBounsNumber,
                onChanged: (value) {
                  searchFilterState.isWithBounsNumber = value;
                },
              ),
              SwitchListTile(
                title: isDraw ? Text('회차 선택') : Text('전체 회차'),
                value: isDraw,
                onChanged: (value) {
                  searchFilterState
                      .setSearchType(value ? SearchType.DRAWS : SearchType.ALL);
                },
              ),
              _makeSearchValueArea(),
              SwitchListTile(
                title:
                    searchFilterState.isAsc ? Text('번호 순서') : Text('당첨 횟수 순서'),
                value: searchFilterState.isAsc,
                onChanged: (value) {
                  searchFilterState.setOrder(value ? Order.ASC : Order.DESC);
                },
              ),
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
    return Consumer<SearchFilterState>(builder: (_, searchFilterState, __) {
      return SearchChoices.single(
        items: (isStart
                ? searchFilterState.searchValues
                : searchFilterState.searchValues.reversed)
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Center(
              child: Text('$value 회'),
            ),
          );
        }).toList(),
        value: isStart
            ? searchFilterState.searchStartValue
            : searchFilterState.searchEndValue,
        searchHint: '회차를 선택하세요',
        onChanged: (newValue) {
          if (newValue == null) {
            newValue = isStart
                ? searchFilterState.searchValues.first
                : searchFilterState.searchValues.last;
          }

          isStart
              ? searchFilterState.searchStartValue = newValue
              : searchFilterState.searchEndValue = newValue;
        },
        dialogBox: true,
        isExpanded: true,
        displayClearIcon: false,
        underline: Container(),
        readOnly: !searchFilterState.isDraw,
        keyboardType: TextInputType.number,
      );
    });
  }

  _stats() {
    return Consumer<StatState>(builder: (_, statState, __) {
      var list = statState.list;

      if (list.length == 0) {
        return Center(child: AppIndicator());
      }

      if (!statState.isOrderAsc) {
        list = list.reversed.toList();
      }

      return Expanded(
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: LottoNumber(number: list[index]),
              trailing: Text('101회 당첨'),
              title: LinearPercentIndicator(
                animation: true,
                lineHeight: 20.0,
                percent: (index * 2) / 100,
                progressColor: Colors.blue,
              ),
            );
          },
        ),
      );
    });
  }
}
