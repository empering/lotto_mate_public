import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lotto_mate/commons/app_box_decoration.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/models/buy.dart';
import 'package:lotto_mate/pages/buy/history_view.dart';
import 'package:lotto_mate/states/buy_history_state.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';
import 'package:lotto_mate/widgets/app_indicator.dart';
import 'package:lotto_mate/widgets/lotto_number.dart';
import 'package:provider/provider.dart';

class HistoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BuyHistoryState()..getBuys(),
      child: Consumer<BuyHistoryState>(
        builder: (_, buyHistoryState, __) {
          return Scaffold(
            appBar: AppAppBar('나의 로또 히스토리'),
            body: Container(
              child: buyHistoryState.buys.length > 0
                  ? this._makeHistoryListView(buyHistoryState)
                  : Center(child: AppIndicator()),
            ),
          );
        },
      ),
    );
  }

  _makeHistoryListView(BuyHistoryState buyHistoryState) {
    var buys = buyHistoryState.buys;

    return ListView.separated(
      controller: buyHistoryState.listViewController,
      padding: const EdgeInsets.all(10.0),
      separatorBuilder: (context, index) => Divider(),
      itemCount: buys.length + 1,
      itemBuilder: (context, index) {
        if (index < buys.length) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: AppBoxDecoration().circular(),
            child: ListTile(
              leading: _makeBuyListLeading(buys[index]),
              title: _makeBuyListViewTitle(buys[index]),
              dense: true,
              onTap: () {
                Get.to(HistoryView(buys[index]));
              },
            ),
          );
        }

        if (buyHistoryState.hasMore) {
          return Center(child: AppIndicator());
        } else {
          return Center(child: Text('더 이상 데이터가 없습니다'));
        }
      },
    );
  }

  _makeBuyListLeading(Buy buy) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${buy.drawId} 회',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          '총 ${buy.picks!.length} 응모',
          style: TextStyle(fontSize: 12.0),
        ),
      ],
    );
  }

  _makeBuyListViewTitle(Buy buy) {
    var picks = buy.picks;
    if (picks != null) {
      return Column(
        children: picks.map((pick) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: pick.numbers!
                  .take(5)
                  .map(
                    (n) => LottoNumber(
                      number: n,
                      fontSize: 16,
                    ),
                  )
                  .toList(),
            ),
          );
        }).toList(),
      );
    } else {
      return Container();
    }
  }
}
