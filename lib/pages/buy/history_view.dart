import 'package:flutter/material.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/models/buy.dart';
import 'package:lotto_mate/models/draw.dart';
import 'package:lotto_mate/states/history_view_state.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';
import 'package:lotto_mate/widgets/lotto_number.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HistoryView extends StatelessWidget {
  final Buy buy;

  HistoryView(this.buy);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar('구매내역 상세'),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: ChangeNotifierProvider(
          create: (_) => HistoryViewState(this.buy)..getPickResult(),
          child: Consumer<HistoryViewState>(
            builder: (context, historyViewState, child) {
              if (historyViewState.loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //== 추첨기본정보 영역 ==//
                    ...historyViewState.draw != null
                        ? _makeDrawInfo(historyViewState.draw!)
                        : _makeBeforeDrawInfo(),
                    SizedBox(height: 30),
                    //== 당첨결과 합계 영역 시작 ==//
                    Container(
                      child: Column(
                        children: _makeTotPrize(historyViewState.totAmount,
                            historyViewState.draw != null),
                      ),
                    ),
                    //== 당첨결과 합계 영역 끝 ==//
                    SizedBox(height: 30),
                    //== 구매정보 영역 시작 ==//
                    Container(
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
                    //== 구매정보 영역 시작 ==//
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _makeDrawInfo(Draw draw) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${buy.drawId}회',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 15),
          Text(
            '당첨결과',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      SizedBox(height: 10),
      Text(
        '(${draw.getDrawDateString()} 추첨)',
        style: TextStyle(color: AppColors.sub),
      ),
      SizedBox(height: 25),
      //== 당첨번호 영역 시작 ==//
      Container(
        child: Column(
          children: [
            Text('당첨 번호'),
            SizedBox(height: 10),
            _makeDraw(draw.numbers!),
          ],
        ),
      ),
    ];
  }

  _makeBeforeDrawInfo() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${buy.drawId}회',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 15),
          Text(
            '당첨결과',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      SizedBox(height: 10),
      Text(
        '(아직 추첨 전 입니다)',
        style: TextStyle(color: Colors.grey),
      ),
      SizedBox(height: 25),
    ];
  }

  _makeDraw(List<int?> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              LottoNumber(number: numbers[0]),
              LottoNumber(number: numbers[1]),
              LottoNumber(number: numbers[2]),
              LottoNumber(number: numbers[3]),
              LottoNumber(number: numbers[4]),
              LottoNumber(number: numbers[5]),
            ],
          ),
        ),
        SizedBox(
          width: 40,
          child: Icon(Icons.add),
        ),
        LottoNumber(number: numbers[6]),
      ],
    );
  }

  _makeMyPicks(List<Pick>? picks, List<int?>? winNumbers) {
    var index = 1;
    var result = [];

    if (picks == null) {
      result.add(Center(child: CircularProgressIndicator()));
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

  _makeTotPrize(num totAmount, bool isDraw) {
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
          '아직 추첨 전 입니다. 🥱',
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
