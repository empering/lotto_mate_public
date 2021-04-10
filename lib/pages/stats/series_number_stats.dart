import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lotto_mate/models/search_filter.dart';
import 'package:lotto_mate/models/stat.dart';
import 'package:lotto_mate/states/stat_state.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';
import 'package:lotto_mate/widgets/app_indicator.dart';
import 'package:provider/provider.dart';
import 'package:search_choices/search_choices.dart';

class SeriesNumberStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<StatState>().getStats(statType: StatType.SERIES);

    return Consumer<StatState>(builder: (_, statState, __) {
      SearchFilter searchFilter = statState.searchFilter;
      return Scaffold(
        appBar: AppAppBar('연속번호'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          child: Column(
            children: [
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
      List<SeriesStat> stats = List.from(statState.stats);

      if (stats.length == 0) {
        return Center(child: AppIndicator());
      }

      return Expanded(
        child: ListView.separated(
          controller: statState.listViewController,
          separatorBuilder: (context, index) => Divider(),
          itemCount: stats.length,
          itemBuilder: (context, index) {
            SeriesStat stat = stats[index];

            return ListTile(
              onTap: () {
                print(stat.draws);
              },
              leading: FaIcon(FontAwesomeIcons.fireAlt),
              trailing: Icon(Icons.navigate_next),
              title: Text('${stat.statType} 연속 출현'),
              subtitle: Text('${stat.count} 회'),
            );
          },
        ),
      );
    });
  }
}
