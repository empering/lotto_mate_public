import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lotto_mate/commons/app_box_decoration.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/models/draw.dart';
import 'package:lotto_mate/pages/home/draw_view.dart';
import 'package:lotto_mate/states/draw_list_state.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';
import 'package:lotto_mate/widgets/app_indicator.dart';
import 'package:lotto_mate/widgets/lotto_number.dart';
import 'package:provider/provider.dart';

class DrawList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar('회차별 당첨결과'),
      body: ChangeNotifierProvider(
        create: (_) => DrawListState()..getDraws(),
        child: Container(
          child: Consumer<DrawListState>(
            builder: (context, drawListState, child) =>
                _makeDrawListView(drawListState),
          ),
        ),
      ),
    );
  }

  _makeDrawListView(DrawListState drawListState) {
    var draws = drawListState.draws;

    return ListView.separated(
      controller: drawListState.listViewController,
      padding: const EdgeInsets.all(10.0),
      separatorBuilder: (context, index) => Divider(),
      itemCount: draws.length + 1,
      itemBuilder: (context, index) {
        if (index < draws.length) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            decoration: AppBoxDecoration().circular(),
            child: ListTile(
              leading: _makeDrawListLeading(draws[index].id),
              title: _makeDrawListViewTitle(draws[index]),
              subtitle: _makeDrawListViewSubTitle(draws[index]),
              dense: true,
              isThreeLine: true,
              onTap: () {
                Get.to(DrawView(draws[index].id!));
              },
            ),
          );
        }

        if (drawListState.hasMore) {
          return Center(child: AppIndicator());
        } else {
          return Center(child: Text('더 이상 데이터가 없습니다'));
        }
      },
    );
  }

  _makeDrawListLeading(int? id) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$id 회',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  _makeDrawListViewTitle(Draw draw) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ...draw.numbers!
            .take(5)
            .map(
              (n) => LottoNumber(
                number: n,
                fontSize: 16,
              ),
            )
            .toList(),
        Icon(Icons.add),
        LottoNumber(
          number: draw.numbers!.last,
          fontSize: 16,
        ),
      ],
    );
  }

  _makeDrawListViewSubTitle(Draw draw) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '1등 당첨금',
            style: TextStyle(
              fontSize: 16.0,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          VerticalDivider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text('총'),
                  Text(
                    ' ${(draw.totalFirstPrizeAmount! / 100000000).round()}억 ',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '원',
                    style: TextStyle(color: AppColors.primary),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '(${draw.firstPrizewinnerCount}명 / ${(draw.eachFirstPrizeAmount! / 100000000).round()}억)',
                    style: TextStyle(color: AppColors.sub),
                  ),
                ],
              ),
              Text(
                '${draw.drawDate} 추첨',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
