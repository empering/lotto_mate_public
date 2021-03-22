import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/models/buy.dart';
import 'package:lotto_mate/states/buy_state.dart';
import 'package:lotto_mate/widgets/app_flat_button.dart';
import 'package:provider/provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class FormButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var buyState = Provider.of<BuyState>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AppTextButton(
          labelText: '추가',
          labelIcon: Icons.add,
          buttonColor: AppColors.primaryLight,
          onPressed: () {
            buyState.setPickedDefault();
            buyState.addNewPick();
          },
        ),
        AppTextButton(
          labelText: '저장',
          labelIcon: Icons.done_all,
          disabled: !buyState.getCanSave,
          onPressed: () {
            buyState.insert();
            Get.defaultDialog(
              title: "처리완료",
              middleText: "저장완료되었습니다.",
            );
          },
        ),
        AppTextButton(
          labelText: 'QR',
          labelIcon: Icons.qr_code_scanner,
          buttonColor: AppColors.accent,
          onPressed: () async {
            if (!await _getQrData(context, buyState)) {
              Get.defaultDialog(
                title: "QR 스캔 오류",
                middleText: "QR 코드 정보 스캔이 잘못되었습니다.\n다시 시도해주세요.",
              );
            }
          },
        ),
        AppTextButton(
          labelText: '삭제',
          labelIcon: Icons.remove,
          buttonColor: AppColors.primaryLight,
          onPressed: () {
            Get.defaultDialog(
              title: "ㅇㅇ?",
              middleText: "ㅎㅇㅎㅇㅎㅇㅎㅇ",
            );
            buyState.popPick();
          },
        ),
      ],
    );
  }

  Future _getQrData(BuildContext context, BuyState buyState) async {
    String qrCodeData = await scanner.scan();
    // http://m.dhlottery.co.kr/?v=0933m020719324142m091819354144m091116264145m161921253233m0708161935431964500808
    // http://m.dhlottery.co.kr/?v=0937q030416354143q131417182435q101619212428n000000000000n0000000000001053764487
    if (qrCodeData.indexOf('http://m.dhlottery.co.kr/?v=') < 0) {
      return false;
    } else {
      String qrData = qrCodeData.split('v=')[1];
      buyState.setBuy = Buy.fromQr(qrData);
      return true;
    }
  }
}
