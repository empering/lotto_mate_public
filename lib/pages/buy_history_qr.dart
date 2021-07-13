import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lotto_mate/commons/number_range_text_input_formatter.dart';
import 'package:lotto_mate/models/buy.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class BuyHistoryQr extends StatefulWidget {
  @override
  _BuyHistoryQrState createState() => _BuyHistoryQrState();
}

class _BuyHistoryQrState extends State<BuyHistoryQr> {
  final _formKey = GlobalKey<FormState>();
  bool v = false;

  Buy buy = Buy(drawId: 936, picks: [
    Pick(type: "q", numbers: List.filled(6, null, growable: false)),
    Pick(type: "q", numbers: List.filled(6, null, growable: false)),
    Pick(type: "q", numbers: List.filled(6, null, growable: false)),
    Pick(type: "q", numbers: List.filled(6, null, growable: false)),
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('구매내역 등록'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          child: FocusTraversalGroup(
            child: Form(
              key: _formKey,
              onChanged: () {
                // Form.of(primaryFocus.context).save();
              },
              child: Column(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints.tight(Size(80, 55)),
                    child: _makeDrawIdDropDownButton(),
                  ),
                  ..._makeLottoNumberForms(buy.picks!),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _scan(),
        tooltip: '등록',
        elevation: 10,
        child: Icon(Icons.send),
      ),
    );
  }

  _makeDrawIdDropDownButton() => DropdownButtonFormField<String>(
        value: '${buy.drawId}',
        items: <String>['937', '936', '935', '934', '933']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text('$value회'),
          );
        }).toList(),
        onChanged: (String? newValue) {},
        onSaved: (String? value) {
          buy.drawId = int.parse(value!);
        },
      );

  _makeLottoNumberForms(List<Pick> picks) => picks.map((e) {
        print(e.type);
        print(e.numbers);
        return _makeLottoNumberForm(e);
      }).toList();

  _makeLottoNumberForm(Pick pick) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            value: pick.type == 'q',
            onChanged: (value) {
              setState(() {
                pick.type = value! ? 'q' : 'm';
              });
            },
          ),
          Text(pick.type == 'q' ? '자동' : '수동'),
          SizedBox(
            width: 20,
          ),
          ...List<Widget>.generate(6, (index) {
            return Padding(
              padding: EdgeInsets.all(5.0),
              child: SizedBox(
                width: 25,
                child: TextFormField(
                  initialValue: pick.numbers![index] != null
                      ? pick.numbers![index].toString()
                      : '',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    NumberRangeTextInputFormatter(45),
                    LengthLimitingTextInputFormatter(2),
                  ],
                  onSaved: (String? value) {
                    // print('$index value is $value saved!');
                  },
                ),
              ),
            );
          }),
        ],
      );

  Future _scan() async {
    String? qrCodeData = await scanner.scan();
    // http://m.dhlottery.co.kr/?v=0933m020719324142m091819354144m091116264145m161921253233m0708161935431964500808
    // http://m.dhlottery.co.kr/?v=0937q030416354143q131417182435q101619212428n000000000000n0000000000001053764487
    String param = qrCodeData!.split('v=')[1];
    print('param is $param');
    String id = param.substring(0, 4);
    String gameAType = param.substring(4, 5);
    String gameANumber1 = param.substring(5, 7);
    String gameANumber2 = param.substring(7, 9);
    String gameANumber3 = param.substring(9, 11);
    String gameANumber4 = param.substring(11, 13);
    String gameANumber5 = param.substring(13, 15);
    String gameANumber6 = param.substring(15, 17);

    print(id);
    print(gameAType);
    print(gameANumber1);
    print(gameANumber2);
    print(gameANumber3);
    print(gameANumber4);
    print(gameANumber5);
    print(gameANumber6);

    setState(() {
      buy.drawId = int.parse(id);
      buy.picks![0].type = gameAType;
      buy.picks![0].numbers![0] = int.parse(gameANumber1);
      buy.picks![0].numbers![1] = int.parse(gameANumber2);
      buy.picks![0].numbers![2] = int.parse(gameANumber3);
      buy.picks![0].numbers![3] = int.parse(gameANumber4);
      buy.picks![0].numbers![4] = int.parse(gameANumber5);
      buy.picks![0].numbers![5] = int.parse(gameANumber6);
    });
  }
}
