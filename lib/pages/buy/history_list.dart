import 'package:flutter/material.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/models/buy.dart';
import 'package:lotto_mate/pages/buy/widget/history_card.dart';
import 'package:lotto_mate/states/buy_history_state.dart';
import 'package:provider/provider.dart';

class HistoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BuyHistoryState()..getAll(),
      child: Consumer<BuyHistoryState>(
        builder: (context, buyHistoryState, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                '구매내역 상세',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
            ),
            body: Container(
              color: AppColors.background,
              child: buyHistoryState.buys != null
                  ? this._makeGridView(buyHistoryState.buys!)
                  : Center(child: CircularProgressIndicator()),
            ),
          );
        },
      ),
    );
  }

  _makeGridView(List<Buy> buys) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      padding: const EdgeInsets.all(8),
      childAspectRatio: 1,
      children: buys.map<Widget>((buy) => HistoryCard(buy)).toList(),
    );
  }
}
