import 'package:flutter/material.dart';
import 'package:lotto_mate/commons/lotto_color.dart';
import 'package:lotto_mate/commons/lotto_even_odd.dart';
import 'package:lotto_mate/states/recommend_state.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';
import 'package:lotto_mate/widgets/app_indicator.dart';
import 'package:lotto_mate/widgets/lotto_number.dart';
import 'package:provider/provider.dart';

class RecommendResult extends StatelessWidget {
  late final RecommendState _recommendState;

  @override
  Widget build(BuildContext context) {
    _recommendState = context.watch<RecommendState>();

    return Scaffold(
      appBar: AppAppBar('번호생성 결과'),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            ..._makeRecommendOption(),
            Divider(),
            Expanded(
              child: FutureBuilder(
                future: _recommendState.getRecommends(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Center(child: AppIndicator());
                  }
                  return _makeResult(snapshot.data as List<List<int>>);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _makeRecommendOption() {
    return [
      Center(
        child: Text(
          '번호생성 조건',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      ListTile(
        leading: Text('번호'),
        title: Row(
          children: _recommendState.numbers.length == 0
              ? [Text('선택된 번호가 없어요.')]
              : _recommendState.numbers
                  .map((number) => Container(
                        padding: const EdgeInsets.all(2.0),
                        child: LottoNumber(
                          number: number,
                          fontSize: 16,
                          numberPicked: (int number) {
                            _recommendState.removeNumber(number);
                          },
                        ),
                      ))
                  .toList(),
        ),
      ),
      ListTile(
        leading: Text('색상'),
        title: Row(
          children: _makeColorsOption(_recommendState.colors),
        ),
      ),
      ListTile(
        leading: Text('홀짝'),
        title: Row(
          children: _makeEvenOddOption(_recommendState.evenOdd),
        ),
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

  _makeResult(List<List<int>> recommends) {
    return ListView.separated(
      padding: const EdgeInsets.all(10.0),
      separatorBuilder: (_, index) => Divider(),
      itemCount: recommends.length,
      itemBuilder: (_, index) {
        return ListTile(
          leading: Text(
            '💸',
            style: TextStyle(fontSize: 30.0),
          ),
          title: _makeRecommendListViewTitle(recommends[index]),
        );
      },
    );
  }

  _makeRecommendListViewTitle(List<int> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: numbers
          .map((n) => LottoNumber(
                number: n,
                isFixedNumber: _recommendState.numbers.contains(n),
              ))
          .toList(),
    );
  }
}
