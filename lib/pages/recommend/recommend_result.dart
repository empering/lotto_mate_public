import 'package:flutter/material.dart';
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
      body: FutureBuilder(
        future: _recommendState.getRecommends(),
        builder: (_, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: AppIndicator());
          }
          return _makeResult(snapshot.data as List<List<int>>);
        },
      ),
    );
  }

  _makeResult(List<List<int>> recommends) {
    return Container(
      child: ListView.separated(
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
      ),
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
