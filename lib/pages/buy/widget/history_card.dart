import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/models/buy.dart';
import 'package:lotto_mate/pages/buy/history_view.dart';
import 'package:lotto_mate/widgets/app_circle_icon_button.dart';
import 'package:lotto_mate/widgets/lotto_number.dart';

class HistoryCard extends StatelessWidget {
  final Buy buy;

  HistoryCard(this.buy);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      footer: Material(
        child: GridTileBar(
          trailing: AppCircleIconButton(
            icon: Icon(Icons.library_books),
            onPressed: () {
              Get.to(HistoryView(buy));
            },
          ),
          backgroundColor: AppColors.backgroundLight,
          title: Text(
            '${buy.drawId} 회차',
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            '총 ${buy.picks!.length}회 응모',
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: 15,
            ),
          ),
        ),
      ),
      child: Material(
        color: AppColors.backgroundAccent,
        elevation: 15.0,
        child: Column(
          children: buy.picks != null
              ? buy.picks!.map((e) => _buildPickNumbers(e)).take(4).toList()
              : [],
        ),
      ),
    );
  }

  Widget _buildPickNumbers(Pick pick) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: pick.numbers!
            .map((e) => LottoNumber(
                  number: e,
                  fontSize: 13,
                ))
            .toList(),
      ),
    );
  }
}
