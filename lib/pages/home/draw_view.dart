import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/models/draw.dart';
import 'package:lotto_mate/pages/home/draw_info.dart';
import 'package:lotto_mate/states/draw_view_state.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';
import 'package:lotto_mate/widgets/app_indicator.dart';
import 'package:provider/provider.dart';

class DrawView extends StatelessWidget {
  final int drawId;

  DrawView(this.drawId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar('당첨결과'),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: ChangeNotifierProvider(
          create: (_) => DrawViewState(drawId)..getDraw(),
          child: Consumer<DrawViewState>(
            builder: (context, drawViewState, child) {
              if (drawViewState.draw == null) {
                return Center(child: AppIndicator());
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  DrawInfo(drawViewState.draw!),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundAccent,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Column(
                        children: [
                          _firstPrizesInfo(drawViewState.draw!),
                          SizedBox(height: 20.0),
                          _detailPrizesInfo(drawViewState.draw!),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  _firstPrizesInfo(Draw draw) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🥇 1등 당첨 정보',
          style: TextStyle(fontSize: 20.0),
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${NumberFormat.decimalPattern('ko').format(draw.totalFirstPrizeAmount)} 원',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10.0),
            Text(
              '총 ${draw.firstPrizewinnerCount}게임 당첨',
              style: TextStyle(color: AppColors.sub),
            ),
          ],
        ),
      ],
    );
  }

  _detailPrizesInfo(Draw draw) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🎖 이번회차 당첨 결과',
          style: TextStyle(fontSize: 20.0),
        ),
        SizedBox(height: 10.0),
        Table(
          border: TableBorder.all(color: Colors.grey),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const <int, TableColumnWidth>{
            0: FixedColumnWidth(40),
            1: FlexColumnWidth(),
            2: FixedColumnWidth(75),
            3: FlexColumnWidth(),
          },
          children: [
            TableRow(
              decoration: const BoxDecoration(color: AppColors.backgroundLight),
              children: [
                _tableCell('순위'),
                _tableCell('총 당첨금'),
                _tableCell('게임 수'),
                _tableCell('게임당 당첨금'),
              ],
            ),
            ...?draw.prizes
                ?.map((prize) => TableRow(
                    children: _tableRowChildren(
                        '${prize.rank}등',
                        prize.totalAmount,
                        prize.winnerCount,
                        prize.eachAmount)))
                .toList(),
          ],
        ),
      ],
    );
  }

  _tableCell(String value, {TextStyle? style}) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            value,
            style: style?.copyWith(fontSize: 12.0) ?? TextStyle(fontSize: 12.0),
          ),
        ),
      ),
    );
  }

  _tableRowChildren(
      String rankName, num? totalAmount, num? winCount, num? eachAmount) {
    return <Widget>[
      _tableCell(rankName),
      _tableCell(
        '${NumberFormat.decimalPattern().format(totalAmount)}원',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      _tableCell('$winCount'),
      _tableCell('${NumberFormat.decimalPattern().format(eachAmount)}원'),
    ];
  }
}
