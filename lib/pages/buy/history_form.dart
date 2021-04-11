import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/pages/buy/widget/draw_id_dropdown.dart';
import 'package:lotto_mate/pages/buy/widget/lotto_number_forms.dart';
import 'package:lotto_mate/states/buy_state.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';
import 'package:lotto_mate/widgets/lotto_number_pad.dart';
import 'package:provider/provider.dart';

class HistoryForm extends StatelessWidget {
  final isFirst;

  HistoryForm({this.isFirst = true});

  @override
  Widget build(BuildContext context) {
    return Consumer<BuyState>(builder: (_, buyState, __) {
      return Scaffold(
        appBar: AppAppBar('로또 번호 ${isFirst ? '등록' : '수정'}'),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DrawIdDropdown(),
              Expanded(
                child: SingleChildScrollView(
                  child: LottoNumberForms(),
                ),
              ),
              Divider(),
              LottoNumberPad(numberPicked: (value) {
                if (value != null) {
                  buyState.pickNumber(value);
                }
              }),
              // FormButton(),
              ButtonBar(
                alignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      buyState.setPickedDefault();
                      buyState.addNewPick();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      buyState.popPick();
                    },
                  ),
                ],
              )
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done),
          backgroundColor:
              buyState.getCanSave ? AppColors.primary : AppColors.accent,
          foregroundColor:
              buyState.getCanSave ? AppColors.accent : AppColors.light,
          splashColor: AppColors.accent,
          onPressed: () {
            if (buyState.getCanSave) {
              buyState.insert();
              Get.defaultDialog(
                title: "처리완료",
                middleText: "저장완료되었습니다.",
              );
            }
          },
        ),
      );
    });
  }
}
