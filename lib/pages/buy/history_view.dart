import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/models/buy.dart';
import 'package:lotto_mate/models/draw.dart';
import 'package:lotto_mate/pages/home/draw_info.dart';
import 'package:lotto_mate/states/history_list_state.dart';
import 'package:lotto_mate/states/history_state.dart';
import 'package:lotto_mate/states/history_view_state.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';
import 'package:lotto_mate/widgets/app_indicator.dart';
import 'package:lotto_mate/widgets/app_text_button.dart';
import 'package:lotto_mate/widgets/lotto_number.dart';
import 'package:provider/provider.dart';

class HistoryView extends StatelessWidget {
  final Buy buy;
  final HistoryViewType historyViewType;

  HistoryView(this.buy, {this.historyViewType = HistoryViewType.VIEW});

  @override
  Widget build(BuildContext context) {
    context.read<HistoryViewState>()
      ..historyViewType = historyViewType
      ..setBuy(buy)
      ..getPickResult();

    return Consumer<HistoryViewState>(builder: (_, historyViewState, __) {
      return Scaffold(
        appBar: AppAppBar('${historyViewState.appBarTitle}'),
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: historyViewState.loading
              ? Center(
                  child: AppIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    historyViewState.draw != null
                        ? DrawInfo(historyViewState.draw!)
                        : _makeBeforeDrawInfo(),
                    Column(
                      children: _makeTotPrize(
                        historyViewState.totAmount,
                        historyViewState.draw,
                        historyViewState.isRanked,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                      child: Column(
                        children: [
                          Text('나의 선택 번호'),
                          SizedBox(height: 5),
                          ..._makeMyPicks(
                            historyViewState.buy.picks,
                            historyViewState.draw != null
                                ? historyViewState.draw!.numbers
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
        persistentFooterButtons: [
          historyViewState.historyViewType == HistoryViewType.VIEW
              ? IconButton(
                  icon: Icon(Icons.delete),
                  splashRadius: 24.0,
                  onPressed: () {
                    Get.defaultDialog(
                      title: '확인해주세요',
                      middleText: '정말 삭제하나요??',
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
                                Get.close(2);
                              },
                            ),
                            AppTextButton(
                              labelIcon: Icons.cancel_outlined,
                              labelText: '취소',
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          ],
                        )
                      ],
                    );
                  },
                )
              : Container(),
          IconButton(
            icon: Icon(Icons.share),
            splashRadius: 24.0,
            onPressed: () {
              Get.defaultDialog(
                title: '이런...',
                middleText: '공유기능은 아직 준비중이에요.',
              );
            },
          ),
        ],
      );
    });
  }

  _makeBeforeDrawInfo() {
    return Builder(
      builder: (context) {
        return Column(
          children: [
            Text(
              '${buy.drawId}회 당첨결과',
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(height: 10),
            Text(
              '아직 추첨 전 입니다',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.sub,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 70),
          ],
        );
      },
    );
  }

  _makeMyPicks(List<Pick>? picks, List<int?>? winNumbers) {
    var index = 1;
    var result = [];

    if (picks == null) {
      result.add(Center(child: AppIndicator()));
    } else {
      picks.forEach((pick) {
        result.add(SizedBox(height: 10));
        result.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${String.fromCharCode(64 + index++)}',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(
                width: 40,
                child: Center(
                  child: Text(
                    winNumbers != null ? pick.pickResult?.rankName ?? '' : '🥱',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              LottoNumber(number: pick.numbers![0], winNumbers: winNumbers),
              LottoNumber(number: pick.numbers![1], winNumbers: winNumbers),
              LottoNumber(number: pick.numbers![2], winNumbers: winNumbers),
              LottoNumber(number: pick.numbers![3], winNumbers: winNumbers),
              LottoNumber(number: pick.numbers![4], winNumbers: winNumbers),
              LottoNumber(number: pick.numbers![5], winNumbers: winNumbers),
            ],
          ),
        );
      });
    }

    return result;
  }

  _makeTotPrize(num totAmount, Draw? draw, bool isRanked) {
    bool isDraw = draw != null;

    if (totAmount > 0) {
      return [
        Text('축하합니다!'),
        Text(
          '총 ${NumberFormat.decimalPattern('ko').format(totAmount)}원 당첨 🤗',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ];
    } else if (!isDraw) {
      return [
        Text('조금 더 기다려 주세요,'),
        Text(
          isRanked ? '당첨금 집계 중입니다 😅' : '아직 추첨 전 입니다. 🥱',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ];
    } else {
      return [
        Text('아쉽게도,'),
        Text(
          '낙첨되었습니다. 😢',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ];
    }
  }
}
