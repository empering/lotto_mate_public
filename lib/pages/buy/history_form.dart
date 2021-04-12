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
  final bool isFirst;
  final HistoryFormType formType;

  HistoryForm({this.isFirst = true, this.formType = HistoryFormType.MANUAL});

  @override
  Widget build(BuildContext context) {
    context.read<BuyState>().formType = this.formType;

    return Consumer<BuyState>(builder: (_, buyState, __) {
      return Scaffold(
        appBar: AppAppBar('로또 번호 ${isFirst ? '등록' : '수정'}'),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DrawIdDropdown(),
              Expanded(
                child: SingleChildScrollView(
                  child: LottoNumberForms(),
                ),
              ),
              Divider(),
              formType == HistoryFormType.MANUAL
                  ? LottoNumberPad(numberPicked: (value) {
                      if (value != null) {
                        buyState.pickNumber(value);
                      }
                    })
                  : Container(),
              // FormButton(),
              formType == HistoryFormType.MANUAL
                  ? ButtonBar(
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
                  : Container(height: 45.0),
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
                title: "저장완료",
                middleText: "나의 로또 히스토리에서 확인 할 수 있어요.",
              );
            }
          },
        ),
      );
    });
  }
}
