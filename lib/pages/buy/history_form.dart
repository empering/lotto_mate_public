import 'package:flutter/material.dart';
import 'package:lotto_mate/pages/buy/widget/draw_id_dropdown.dart';
import 'package:lotto_mate/pages/buy/widget/form_button.dart';
import 'package:lotto_mate/pages/buy/widget/lotto_number_forms.dart';
import 'package:lotto_mate/pages/buy/widget/lotto_number_pad.dart';
import 'package:lotto_mate/states/buy_state.dart';
import 'package:provider/provider.dart';

class HistoryForm extends StatelessWidget {
  // CollectionReference buys = FirebaseFirestore.instance.collection('buys');

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BuyState(),
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text('구매내역 등록'),
        // ),
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
    );
  }
}
