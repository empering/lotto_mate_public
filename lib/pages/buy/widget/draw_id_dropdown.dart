import 'package:flutter/material.dart';
import 'package:lotto_mate/states/buy_state.dart';
import 'package:provider/provider.dart';
import 'package:search_choices/search_choices.dart';

class DrawIdDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: _makeChoices(),
    );
  }

  _makeChoices() {
    return Consumer<BuyState>(builder: (_, buyState, __) {
      return SearchChoices.single(
        value: '${buyState.buy!.drawId}',
        items: List<String>.generate(
                25, (index) => '${buyState.thisWeekDrawId + 1 - index}')
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text('$value회'),
          );
        }).toList(),
        searchHint: '회차를 선택하세요',
        onChanged: (String? newValue) {
          buyState.setDrawId = int.parse(newValue!);
        },
        dialogBox: true,
        isExpanded: true,
        displayClearIcon: false,
        readOnly: buyState.formType == HistoryFormType.QR,
        underline: Container(),
        keyboardType: TextInputType.number,
      );
    });
  }
}
