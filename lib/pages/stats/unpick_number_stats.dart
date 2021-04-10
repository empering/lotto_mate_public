import 'package:flutter/material.dart';
import 'package:lotto_mate/commons/app_box_decoration.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/commons/lotto_color.dart';
import 'package:lotto_mate/models/search_filter.dart';
import 'package:lotto_mate/states/stat_state.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';
import 'package:lotto_mate/widgets/app_indicator.dart';
import 'package:lotto_mate/widgets/lotto_number.dart';
import 'package:provider/provider.dart';

class UnpickNumberStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<StatState>().getStats(statType: StatType.UNPICK);

    return Consumer<StatState>(builder: (_, statState, __) {
      SearchFilter searchFilter = statState.searchFilter;
      return Scaffold(
        appBar: AppAppBar('미출현번호'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          child: Column(
            children: [
              _makeSearchValueArea(),
              SwitchListTile(
                title: Text(
                    '보너스 번호 ${searchFilter.isWithBounsNumber ? '포함' : '제외'}'),
                value: searchFilter.isWithBounsNumber,
                onChanged: (value) {
                  searchFilter.isWithBounsNumber = value;

                  statState.notify();
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
    return Consumer<StatState>(
      builder: (_, statState, __) {
        return Wrap(
          spacing: 10.0,
          children: List<Widget>.generate(
            4,
            (int index) {
              var drawIdDiff = (index + 1) * 5;
              return ChoiceChip(
                label: Text('최근 $drawIdDiff회'),
                selected: drawIdDiff == statState.drawIdDiff,
                selectedColor: AppColors.sub,
                elevation: 10.0,
                onSelected: (bool selected) {
                  statState.changeRecentDrawId(drawIdDiff);
                },
              );
            },
          ).toList(),
        );
      },
    );
  }

  _stats() {
    return Consumer<StatState>(builder: (_, statState, __) {
      List<int> stats = List.from(statState.stats);

      if (stats.length == 0) {
        return Center(child: AppIndicator());
      }

      if (stats.length == 1 && stats.first < 0) {
        stats = [];
      }

      return Expanded(
        child: ListView.separated(
          controller: statState.listViewController,
          separatorBuilder: (context, index) => Divider(),
          itemCount: 5,
          itemBuilder: (context, index) {
            var color = LottoColorType.values[index];
            var numbers = stats.where((number) =>
                LottoColor.getLottoNumberColorType(number) == color);

            return ListTile(
              leading: Container(
                alignment: Alignment.center,
                decoration: AppBoxDecoration(
                  color: LottoColor.getLottoColor(color),
                  blurRadius: 2.0,
                  offset: Offset(1.0, 3.0),
                ).circular(),
                width: 60,
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  LottoColor.getLottoColorTypeDesc(color),
                ),
              ),
              title: Row(
                children: numbers
                    .map((n) => LottoNumber(
                          number: n,
                        ))
                    .toList(),
              ),
            );
          },
        ),
      );
    });
  }
}
