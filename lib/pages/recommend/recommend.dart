import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/commons/lotto_color.dart';
import 'package:lotto_mate/commons/lotto_even_odd.dart';
import 'package:lotto_mate/pages/recommend/recommend_result.dart';
import 'package:lotto_mate/states/recommend_state.dart';
import 'package:lotto_mate/widgets/app_circle_icon_button.dart';
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
          recommendState.getRecommends();
          Get.to(() => RecommendResult());
        },
      ),
    );
  }

  _makeOption(RecommendState recommendState) {
    return [
      ListTile(
        title: Text('번호'),
        trailing: SizedBox(
            width: 50,
            child: AppTextButton(
              labelIcon: Icons.close,
              onPressed: () {
                recommendState.clearNumbers();
              },
            )),
      ),
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
          child: Row(
            children: [
              Expanded(
                child: Wrap(
                  children: recommendState.numbers.length == 0
                      ? [Text('선택된 번호가 없어요.')]
                      : recommendState.numbers.map(
                          (number) {
                            return Container(
                              padding: const EdgeInsets.all(2.0),
                              child: LottoNumber(
                                number: number,
                                fontSize: 14,
                                numberPicked: (int number) {
                                  recommendState.removeNumber(number);
                                },
                              ),
                            );
                          },
                        ).toList(),
                ),
              ),
              AppTextButton(
                labelText: '번호선택',
                buttonColor: AppColors.primary,
                labelColor: AppColors.light,
                onPressed: () {
                  Get.dialog(
                    Center(
                      child: Container(
                        padding: const EdgeInsets.only(top: 10.0),
                        color: AppColors.light,
                        height: 280,
                        child: Column(
                          children: [
                            Expanded(
                              child: LottoNumberPad(
                                fontSize: 14.0,
                                numberPicked: (number) {
                                  if (number == null) return;

                                  if (recommendState.isContains(number)) {
                                    recommendState.removeNumber(number);
                                  } else {
                                    if (!recommendState.numberAddable) {
                                      Get.defaultDialog(
                                        title: '이런...',
                                        middleText:
                                            '번호는 최대 ${recommendState.numbersLimitSize}개 까지만 설정 가능 해요.',
                                      );
                                    } else {
                                      recommendState.addNumber(number);
                                    }
                                  }
                                },
                              ),
                            ),
                            ButtonTheme(
                              minWidth: 78.0,
                              height: 34.0,
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  AppTextButton(
                                    labelIcon: Icons.cancel_outlined,
                                    labelText: '닫기',
                                    onPressed: () {
                                      Get.back();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      ExpansionPanelList(
        expansionCallback: (panelIndex, isExpanded) {
          if (panelIndex == 0) {
            recommendState.isColorExpanded = !isExpanded;
          } else {
            recommendState.isEvenOddExpanded = !isExpanded;
          }
        },
        elevation: 0,
        dividerColor: Colors.transparent,
        expandedHeaderPadding: EdgeInsets.all(0),
        children: [
          ExpansionPanel(
            headerBuilder: (context, isExpanded) {
              return ListTile(title: Text('색상'));
            },
            backgroundColor: AppColors.light,
            canTapOnHeader: true,
            isExpanded: recommendState.isColorExpanded,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  _makeColorCountSlider(recommendState, LottoColorType.yellow),
                  _makeColorCountSlider(recommendState, LottoColorType.blue),
                  _makeColorCountSlider(recommendState, LottoColorType.red),
                  _makeColorCountSlider(recommendState, LottoColorType.gray),
                  _makeColorCountSlider(recommendState, LottoColorType.green),
                ],
              ),
            ),
          ),
          ExpansionPanel(
            headerBuilder: (context, isExpanded) {
              return ListTile(title: Text('홀짝'));
            },
            backgroundColor: AppColors.light,
            canTapOnHeader: true,
            isExpanded: recommendState.isEvenOddExpanded,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  _makeEvenOddCountSlider(recommendState, LottoEvenOddType.odd),
                  _makeEvenOddCountSlider(
                      recommendState, LottoEvenOddType.even),
                ],
              ),
            ),
          ),
        ],
      ),
      SizedBox(height: 80)
    ];
  }

  _makeColorCountSlider(RecommendState recommendState, LottoColorType color) {
    String colorName = LottoColor.getLottoColorTypeName(color);
    return ListTile(
      leading: AppCircleIconButton(
        icon: Icon(Icons.exposure_minus_1),
        iconColor: AppColors.primary,
        splashColor: AppColors.accent,
        splashRadius: 24.0,
        onPressed: () {
          recommendState.minusColorCount(color);
        },
      ),
      trailing: AppCircleIconButton(
        icon: Icon(Icons.exposure_plus_1),
        iconColor: AppColors.primary,
        splashColor: AppColors.accent,
        splashRadius: 24.0,
        onPressed: () {
          recommendState.plusColorCount(color);
        },
      ),
      title: Center(
        child: Text('$colorName : ${recommendState.colors[color]} 개 이상'),
      ),
    );
  }

  _makeEvenOddCountSlider(
      RecommendState recommendState, LottoEvenOddType evenOdd) {
    String evenOddName = LottoEvenOdd.getEvenOddTypeName(evenOdd);
    return ListTile(
      leading: AppCircleIconButton(
        icon: Icon(Icons.exposure_minus_1),
        iconColor: AppColors.primary,
        splashColor: AppColors.accent,
        splashRadius: 24.0,
        onPressed: () {
          recommendState.minusEvenOddCount(evenOdd);
        },
      ),
      trailing: AppCircleIconButton(
        icon: Icon(Icons.exposure_plus_1),
        iconColor: AppColors.primary,
        splashColor: AppColors.accent,
        splashRadius: 24.0,
        onPressed: () {
          recommendState.plusEvenOddCount(evenOdd);
        },
      ),
      title: Center(
        child: Text('$evenOddName수 : ${recommendState.evenOdd[evenOdd]} 개 이상'),
      ),
    );
  }
}
