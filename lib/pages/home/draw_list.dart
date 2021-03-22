import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/models/draw.dart';
import 'package:lotto_mate/pages/home/draw_view.dart';
import 'package:lotto_mate/states/draw_list_state.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';
import 'package:lotto_mate/widgets/lotto_number.dart';
import 'package:provider/provider.dart';

class DrawList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar('회차별 당첨결과'),
      backgroundColor: AppColors.background,
      body: ChangeNotifierProvider(
        create: (_) => DrawListState()..getDraws(),
        child: Container(
          child: Consumer<DrawListState>(
            builder: (context, drawListState, child) =>
                _makeDrawListView(drawListState.draws),
          ),
        ),
      ),
    );
  }

  _makeDrawListView(List<Draw> draws) {
    return ListView(
      padding: const EdgeInsets.all(10.0),
      children: draws
          .map(
            (draw) => Column(
              children: [
                ListTile(
                  leading: _makeDrawListLeading(draw.id),
                  title: _makeDrawListViewTitle(draw),
                  subtitle: _makeDrawListViewSubTitle(draw),
                  dense: true,
                  isThreeLine: true,
                  onTap: () {
                    Get.to(DrawView(draw.id!));
                  },
                ),
                Divider(),
              ],
            ),
          )
          .toList(),
    );
  }

  _makeDrawListLeading(int? id) {
    return Text(
      '$id 회',
      style: TextStyle(fontSize: 16.0, color: Colors.black),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '1등 당첨금 : ${draw.totalFirstPrizeAmount! ~/ 100000000}억원',
              style: TextStyle(fontSize: 16.0, color: Colors.black),
            ),
            SizedBox(width: 10),
            Text(
              '(${draw.firstPrizewinnerCount}명 / ${draw.eachFirstPrizeAmount! ~/ 100000000}억)',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        Text('${draw.drawDate} 추첨'),
      ],
    );
  }
}
