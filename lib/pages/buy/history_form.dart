import 'package:flutter/material.dart';
import 'package:lotto_mate/pages/buy/widget/draw_id_dropdown.dart';
import 'package:lotto_mate/pages/buy/widget/form_button.dart';
import 'package:lotto_mate/pages/buy/widget/lotto_number_forms.dart';
import 'package:lotto_mate/pages/buy/widget/lotto_number_pad.dart';
import 'package:lotto_mate/states/buy_state.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';
import 'package:provider/provider.dart';

class HistoryForm extends StatelessWidget {
  final isFirst;

  HistoryForm({this.isFirst = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar('로또 번호 ${isFirst ? '등록' : '수정'}'),
      body: ChangeNotifierProvider(
        create: (_) => BuyState(),
        child: Scaffold(
          body: Consumer<BuyState>(
            builder: (context, buyHistoryState, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        DrawIdDropdown(),
                        LottoNumberForms(),
                      ],
                    ),
                  ),
                  LottoNumberPad(),
                  FormButton(),
                  SizedBox(
                    height: 20,
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
