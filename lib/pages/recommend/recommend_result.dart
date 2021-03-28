import 'package:flutter/material.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';
import 'package:lotto_mate/widgets/lotto_number.dart';

class RecommendResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar('번호생성 결과'),
      body: _makeResult(),
    );
  }

  _makeResult() {
    return Container(
      child: ListView.separated(
        padding: const EdgeInsets.all(10.0),
        separatorBuilder: (context, index) => Divider(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Text('💸'),
            title: _makeRecommendListViewTitle(),
          );
        },
      ),
    );
  }

  _makeRecommendListViewTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ...List.generate(
          6,
          (index) => LottoNumber(
            number: index + 1,
            fontSize: 16,
          ),
        ).toList()
      ],
    );
  }
}
