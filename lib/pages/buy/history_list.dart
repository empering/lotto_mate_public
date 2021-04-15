import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lotto_mate/commons/app_box_decoration.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/models/buy.dart';
import 'package:lotto_mate/pages/buy/history_view.dart';
import 'package:lotto_mate/states/banner_ad_provider.dart';
import 'package:lotto_mate/states/buy_history_state.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';
import 'package:lotto_mate/widgets/app_indicator.dart';
import 'package:lotto_mate/widgets/lotto_number.dart';
import 'package:provider/provider.dart';

class HistoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<BuyHistoryState>().getBuys(isFirst: true);

    var adProvider = context.read<BannerAdProvider>();

    return Scaffold(
      appBar: AppAppBar('나의 로또 히스토리'),
      body: Container(child: this._makeHistoryListView(adProvider)),
    );
  }

  _makeHistoryListView(BannerAdProvider adProvider) {
    return Consumer<BuyHistoryState>(builder: (_, buyHistoryState, __) {
      var buys = buyHistoryState.buys;

      if (buys.length == 0) {
        return Center(child: AppIndicator());
      }

      return ListView.separated(
        controller: buyHistoryState.listViewController,
        padding: const EdgeInsets.all(10.0),
        separatorBuilder: (context, index) => Divider(),
        itemCount: buys.length +
            1 +
            buyHistoryState.ads.length +
            (buyHistoryState.ads.length > 0 ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < buys.length + buyHistoryState.ads.length) {
            if (index % 10 == 5) {
              if (buyHistoryState.ads.length <= (index / 10).floor()) {
                buyHistoryState.ads.add(adProvider.newAd);
              }

              var ad = buyHistoryState.ads[(index / 10).floor()];

              return Container(
                alignment: Alignment.center,
                decoration: AppBoxDecoration(
                  color: Colors.white,
                  shdowColor: Colors.transparent,
                ).circular(),
                child: AdWidget(ad: ad),
                height: 72.0,
              );
            }

            var buy = buys[index - (index / 10).round()];
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: AppBoxDecoration().circular(),
              child: ListTile(
                leading: _makeBuyListLeading(buy),
                title: _makeBuyListViewTitle(buy),
                dense: true,
                onTap: () {
                  Get.to(HistoryView(buy));
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
    });
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
                  .take(6)
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
