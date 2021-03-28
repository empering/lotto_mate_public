import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/pages/recommend/recommend_result.dart';
import 'package:lotto_mate/widgets/app_circle_icon_button.dart';
import 'package:lotto_mate/widgets/app_text_button.dart';
import 'package:lotto_mate/widgets/lotto_number_pad.dart';

class Recommend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: [..._makeOption()],
        ),
      ),
      floatingActionButton: AppCircleIconButton(
        icon: Icon(Icons.check),
        backgroundColor: AppColors.primary,
        iconColor: AppColors.accent,
        onPressed: () {
          Get.to(RecommendResult());
        },
      ),
    );
  }

  _makeOption() {
    return [
      ListTile(
        leading: Text('번호'),
        title: Text('1,2,3,4,5'),
        trailing: SizedBox(
            width: 100,
            child: AppTextButton(
              labelIcon: Icons.close,
              labelText: 'Reset',
              onPressed: () {},
            )),
      ),
      Container(
        child: LottoNumberPad(
          numberPicked: (value) {
            print(value);
          },
        ),
      ),
      Divider(),
      ListTile(
        leading: Text('색상'),
        title: Text('빨, 파, 녹'),
      ),
      Container(
        child: LottoNumberPad(
          numberPicked: (value) {
            print(value);
          },
        ),
      ),
      Divider(),
      ListTile(
        leading: Text('홀짝'),
        title: Text('홀 : 1 이상, 짝 : 2 이상'),
      ),
      Container(
        child: LottoNumberPad(
          numberPicked: (value) {
            print(value);
          },
        ),
      ),
    ];
  }
}
