import 'package:flutter/material.dart';
import 'package:lotto_mate/states/buy_state.dart';
import 'package:provider/provider.dart';

class DrawIdDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var buyHistoryState = Provider.of<BuyState>(context);

    return ConstrainedBox(
      constraints: BoxConstraints.tight(Size(80, 45)),
      child: _makeDrawIdDropDownButton(buyHistoryState),
    );
  }

  _makeDrawIdDropDownButton(BuyState buyState) {
    return DropdownButtonFormField<String>(
      value: '${buyState.buy!.drawId}',
      items: List<String>.generate(
              25, (index) => '${buyState.thisWeekDrawId - index}')
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text('$value회'),
        );
      }).toList(),
      onChanged: (String? newValue) {},
      onSaved: (String? value) {
        buyState.setDrawId = int.parse(value!);
      },
    );
  }
}
