import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/commons/lotto_color.dart';
import 'package:lotto_mate/commons/lotto_even_odd.dart';
import 'package:lotto_mate/states/recommend_state.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';
import 'package:lotto_mate/widgets/app_indicator.dart';
import 'package:lotto_mate/widgets/lotto_number.dart';
import 'package:provider/provider.dart';

class RecommendResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RecommendState recommendState = context.watch<RecommendState>();

    return Scaffold(
      appBar: AppAppBar('번호생성 결과'),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            ..._makeRecommendOption(recommendState),
            Divider(),
            FutureBuilder(
              future: recommendState.waitAdLoaded(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  recommendState.adShow();
                } else {
                  return Center(child: AppIndicator());
                }

                return Expanded(
                  child: recommendState.recommends.length == 0
                      ? Center(child: AppIndicator())
                      : _makeResult(
                          recommendState.recommends, recommendState.numbers),
                );
              },
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        IconButton(
          icon: Icon(Icons.add),
          splashRadius: 24.0,
          onPressed: () {
            Get.defaultDialog(
              title: '이런...',
              middleText: '번호저장기능은 아직 준비중이에요.',
              // title: '번호 저장',
              // middleText: '생성된 번호를 저장할 건가요?',
              // actions: [
              //   IconButton(
              //     icon: Icon(Icons.done),
              //     splashRadius: 24.0,
              //     onPressed: () {
              //       print('okok');
              //       Get.back();
              //     },
              //   ),
              //   IconButton(
              //     icon: Icon(Icons.clear),
              //     splashRadius: 24.0,
              //     onPressed: () {
              //       print('cancel');
              //       Get.back();
              //     },
              //   ),
              // ],
            );
          },
        ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: recommendState.recommends.length == 0
            ? AppIndicator()
            : Icon(Icons.refresh),
        backgroundColor: recommendState.recommends.length == 0
            ? AppColors.light
            : AppColors.primary,
        foregroundColor: AppColors.accent,
        splashColor: AppColors.accent,
        onPressed: () {
          if (recommendState.recommends.length > 0) {
            recommendState.getRecommends();
          }
        },
      ),
    );
  }

  _makeRecommendOption(RecommendState recommendState) {
    return [
      ListTile(
        leading: Text('번호'),
        title: Row(
          children: recommendState.numbers.length == 0
              ? [Text('선택된 번호가 없어요.')]
              : recommendState.numbers
                  .map((number) => Container(
                        padding: const EdgeInsets.all(2.0),
                        child: LottoNumber(
                          number: number,
                          fontSize: 16,
                          numberPicked: (int number) {
                            recommendState.removeNumber(number);
                          },
                        ),
                      ))
                  .toList(),
        ),
        dense: true,
      ),
      ListTile(
        leading: Text('색상'),
        title: Row(
          children: _makeColorsOption(recommendState.colors),
        ),
        dense: true,
      ),
      ListTile(
        leading: Text('홀짝'),
        title: Row(
          children: _makeEvenOddOption(recommendState.evenOdd),
        ),
        dense: true,
      ),
    ];
  }

  _makeColorsOption(Map<LottoColorType, int> colors) {
    var result = <Widget>[];
    colors.forEach((color, count) {
      if (count > 0) {
        result.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
              '${LottoColor.getLottoColorTypeName(color).substring(0, 1)} : $count'),
        ));
      }
    });

    if (result.length == 0) {
      result.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: Text('선택된 색상이 없어요.'),
      ));
    }
    return result;
  }

  _makeEvenOddOption(Map<LottoEvenOddType, int> evenOdd) {
    var result = <Widget>[];
    evenOdd.forEach((eo, count) {
      if (count > 0) {
        result.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text('${LottoEvenOdd.getEvenOddTypeName(eo)} : $count'),
        ));
      }
    });

    if (result.length == 0) {
      result.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: Text('선택된 홀/짝이 없어요.'),
      ));
    }
    return result;
  }

  _makeResult(List<List<int>> recommends, List<int> numbers) {
    return ListView.separated(
      padding: const EdgeInsets.all(10.0),
      separatorBuilder: (_, index) => Divider(),
      itemCount: recommends.length,
      itemBuilder: (_, index) {
        return ListTile(
          leading: FaIcon(
            FontAwesomeIcons.fireAlt,
            color: LottoColor.red,
            size: 30.0,
          ),
          title: _makeRecommendListViewTitle(recommends[index], numbers),
        );
      },
    );
  }

  _makeRecommendListViewTitle(List<int> numbers, List<int> fixedNumbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: numbers
          .map((n) => LottoNumber(
                number: n,
                isFixedNumber: fixedNumbers.contains(n),
                fontSize: 22,
              ))
          .toList(),
    );
  }
}
