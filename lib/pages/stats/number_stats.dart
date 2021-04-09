import 'package:flutter/material.dart';
import 'package:lotto_mate/models/search_filter.dart';
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

    return Consumer<StatState>(builder: (_, statState, __) {
      SearchFilter searchFilter = statState.searchFilter;
      return Scaffold(
        appBar: AppAppBar('번호별'),
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

                  statState.reloadData();
                },
              ),
              SwitchListTile(
                title: searchFilter.isDraw ? Text('회차 선택') : Text('전체 회차'),
                value: searchFilter.isDraw,
                onChanged: (value) {
                  searchFilter
                      .setSearchType(value ? SearchType.DRAWS : SearchType.ALL);

                  statState.reloadData();
                },
              ),
              _makeSearchValueArea(),
              SwitchListTile(
                title: searchFilter.isAsc ? Text('번호 순서') : Text('당첨 횟수 순서'),
                value: searchFilter.isAsc,
                onChanged: (value) {
                  searchFilter.setOrder(value ? Order.ASC : Order.DESC);
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

          statState.reloadData();
        },
        dialogBox: true,
        isExpanded: true,
        displayClearIcon: false,
        underline: Container(),
        readOnly: !searchFilter.isDraw,
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
