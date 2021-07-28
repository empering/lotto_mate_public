import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lotto_mate/commons/app_box_decoration.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/models/buy.dart';
import 'package:lotto_mate/pages/buy/history_view.dart';
import 'package:lotto_mate/states/history_list_state.dart';
import 'package:lotto_mate/states/history_state.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';
import 'package:lotto_mate/widgets/app_indicator.dart';
import 'package:lotto_mate/widgets/app_text_button.dart';
import 'package:lotto_mate/widgets/banner_ad_provider.dart';
import 'package:lotto_mate/widgets/lotto_number.dart';
import 'package:provider/provider.dart';

class HistoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<HistoryListState>().getBuys(isFirst: true);

    var adProvider = context.read<BannerAdProvider>();

    return Scaffold(
      appBar: AppAppBar('나의 로또 히스토리'),
      body: Container(child: this._makeHistoryListView(adProvider)),
    );
  }

  _makeHistoryListView(BannerAdProvider adProvider) {
    return Consumer<HistoryListState>(builder: (_, buyHistoryState, __) {
      var buys = buyHistoryState.buys;

      if (buys.length == 0 && buyHistoryState.isLoading) {
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
              var adWidget;
              if (ad is BannerAd) {
                adWidget = AdWidget(ad: ad);
              } else {
                adWidget = ad;
              }

              return Container(
                alignment: Alignment.center,
                decoration: AppBoxDecoration(
                  color: Colors.white,
                  shdowColor: Colors.transparent,
                ).circular(),
                child: adWidget,
                height: 72.0,
              );
            }

            var buyIndex = index - (index / 10).round();
            var buy = buys[buyIndex];
            return Dismissible(
              key: ValueKey(buyIndex),
              background: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.delete),
                    Text('삭제'),
                  ],
                ),
              ),
              secondaryBackground: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.delete),
                    Text('삭제'),
                  ],
                ),
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart ||
                    direction == DismissDirection.startToEnd) {
                  return await Get.defaultDialog(
                        title: '확인해주세요',
                        middleText: '정말 삭제하나요??',
                        barrierDismissible: true,
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppTextButton(
                                labelIcon: Icons.check_circle_outline,
                                labelText: '확인',
                                onPressed: () async {
                                  await context
                                      .read<HistoryListState>()
                                      .deleteBuy(buy);
                                  context.read<HistoryState>().getHistory();
                                  Get.back(result: true);
                                },
                              ),
                              AppTextButton(
                                labelIcon: Icons.cancel_outlined,
                                labelText: '취소',
                                onPressed: () {
                                  Get.back(result: false);
                                },
                              ),
                            ],
                          )
                        ],
                      ) ??
                      false;
                }
                return false;
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: AppBoxDecoration().circular(),
                child: ListTile(
                  leading: _makeBuyListLeading(buy),
                  title: _makeBuyListViewTitle(buy),
                  dense: true,
                  onTap: () {
                    Get.to(
                      () => HistoryView(buy),
                      transition: Transition.fade,
                    );
                  },
                ),
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
                      fontSize: 19,
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
