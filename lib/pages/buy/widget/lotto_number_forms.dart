import 'package:flutter/material.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/states/buy_state.dart';
import 'package:lotto_mate/widgets/app_indicator.dart';
import 'package:lotto_mate/widgets/lotto_number.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class LottoNumberForms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var buyState = Provider.of<BuyState>(context);

    return _makeLottoNumberForms(buyState);
  }

  Widget _makeLottoNumberForms(final BuyState buyState) {
    var picks = buyState.buy!.picks!;

    if (picks.length == 0) {
      var items;
      if (buyState.cameraPermissionStatus.isGranted) {
        items = [
          AppIndicator(),
          Text('QR 코드를 다시 스캔해주세요.'),
          SizedBox(height: 20.0),
          FloatingActionButton(
            child: Icon(Icons.refresh),
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.accent,
            splashColor: AppColors.accent,
            heroTag: null,
            onPressed: () {
              buyState.scanQr();
            },
          ),
        ];
      } else {
        items = [
          AppIndicator(),
          Text('QR 코드 스캔을 위해 권한이 필요해요.'),
          SizedBox(height: 20.0),
          Text('권한 설정하기'),
          SizedBox(height: 10.0),
          FloatingActionButton(
            child: Icon(Icons.settings),
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.accent,
            splashColor: AppColors.accent,
            heroTag: null,
            onPressed: () {
              buyState.appSetting();
            },
          ),
        ];
      }

      return Center(
        child: Column(
          children: items,
        ),
      );
    }

    List<Widget> lottoNumberForms = [];
    picks.forEach((pick) {
      lottoNumberForms.add(GestureDetector(
        onTap: () {
          buyState.setPickedThis(pick);
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primary,
                width: pick.isPicked! ? 1 : 0,
              ),
              borderRadius: BorderRadius.circular(10),
              color: pick.isPicked! ? AppColors.accent : AppColors.light),
          margin: EdgeInsets.fromLTRB(15, 2, 15, 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  buyState.togglePickType(pick);
                },
                style: TextButton.styleFrom(minimumSize: Size(15.0, 15.0)),
                child: Text(
                  pick.type == 'q' ? '자동' : '수동',
                  style: TextStyle(
                    color: pick.type == 'q' ? AppColors.primary : Colors.black,
                    fontWeight:
                        pick.type == 'q' ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              ...pick.numbers!
                  .map((int? value) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: GestureDetector(
                          onTap: () {
                            buyState.popNumber(pick, value);
                          },
                          child: LottoNumber(number: value),
                        ),
                      ))
                  .toList(),
            ],
          ),
        ),
      ));
    });

    return Container(
      child: Column(
        children: lottoNumberForms,
      ),
    );
  }
}
