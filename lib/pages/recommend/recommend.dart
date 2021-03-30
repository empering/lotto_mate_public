import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/pages/recommend/recommend_result.dart';
import 'package:lotto_mate/states/recommend_state.dart';
import 'package:lotto_mate/widgets/app_text_button.dart';
import 'package:lotto_mate/widgets/lotto_number.dart';
import 'package:lotto_mate/widgets/lotto_number_pad.dart';
import 'package:provider/provider.dart';

class Recommend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RecommendState recommendState = context.watch<RecommendState>();

    return Scaffold(
      body: Container(
        child: ListView(
          children: [..._makeOption(recommendState)],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.accent,
        splashColor: AppColors.accent,
        onPressed: () {
          Get.to(RecommendResult());
        },
      ),
    );
  }

  _makeOption(RecommendState recommendState) {
    return [
      ListTile(
        title: Row(
          children: [
            Text('번호'),
            SizedBox(width: 20),
            ...recommendState.numbers
                .map((number) => Container(
                      padding: const EdgeInsets.all(4.0),
                      child: LottoNumber(
                        number: number,
                        fontSize: 14,
                      ),
                    ))
                .toList()
          ],
        ),
        trailing: SizedBox(
            width: 50,
            child: AppTextButton(
              labelIcon: Icons.close,
              onPressed: () {},
            )),
      ),
      Container(
        child: LottoNumberPad(
          numberPicked: (number) {
            if (number == null) return;

            if (recommendState.isContains(number)) {
              recommendState.removeNumber(number);
            } else {
              if (!recommendState.numberAddable) {
                Get.defaultDialog(
                  title: '이런...',
                  middleText: '번호는 최대 6개 까지만 설정 가능 해요.',
                );
              } else {
                recommendState.addOrRemoveNumbers(number);
              }
            }
          },
        ),
      ),
      Divider(),
      ListTile(title: Text('색상')),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            _makeColorCountSlider(recommendState, LottoColors.yellow),
            _makeColorCountSlider(recommendState, LottoColors.blue),
            _makeColorCountSlider(recommendState, LottoColors.red),
            _makeColorCountSlider(recommendState, LottoColors.gray),
            _makeColorCountSlider(recommendState, LottoColors.green),
          ],
        ),
      ),
      Divider(),
      ListTile(title: Text('홀짝')),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            _makeEvenOddCountSlider(recommendState, LottoEvenOdd.odd),
            _makeEvenOddCountSlider(recommendState, LottoEvenOdd.even),
          ],
        ),
      ),
    ];
  }

  _makeColorCountSlider(RecommendState recommendState, LottoColors color) {
    String colorName = recommendState.getColorName(color);
    return ListTile(
      leading: Text('$colorName : ${recommendState.colors[color]} 개 이상'),
      title: Slider(
        value: recommendState.colors[color]! * 1.0,
        min: 0,
        max: 6,
        divisions: 6,
        label: recommendState.colors[color]!.toString(),
        onChanged: (double count) {
          recommendState.setColorCount(color, count.floor());
        },
        inactiveColor: AppColors.light,
        activeColor: AppColors.primary,
      ),
    );
  }

  _makeEvenOddCountSlider(RecommendState recommendState, LottoEvenOdd evenOdd) {
    String evenOddName = LottoEvenOdd.odd == evenOdd ? '홀' : '짝';
    return ListTile(
      leading: Text('$evenOddName수 : ${recommendState.evenOdd[evenOdd]} 개 이상'),
      title: Slider(
        value: recommendState.evenOdd[evenOdd]! * 1.0,
        min: 0,
        max: 6,
        divisions: 6,
        label: recommendState.evenOdd[evenOdd]!.toString(),
        onChanged: (double count) {
          recommendState.setEvenOddCount(evenOdd, count.floor());
        },
        inactiveColor: AppColors.light,
        activeColor: AppColors.primary,
      ),
    );
  }
}
