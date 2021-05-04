import 'package:flutter/material.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/models/draw.dart';
import 'package:lotto_mate/widgets/lotto_number.dart';

class DrawInfo extends StatelessWidget {
  final Draw draw;

  DrawInfo(this.draw);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '${draw.id}회 당첨결과',
          style: Theme.of(context).textTheme.headline1,
        ),
        SizedBox(height: 5),
        Text(
          '${draw.getDrawDateString()} 추첨',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.sub,
            fontSize: 20,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
          child: Column(
            children: [
              Text('당첨 번호'),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  LottoNumber(number: draw.numbers?[0]),
                  LottoNumber(number: draw.numbers?[1]),
                  LottoNumber(number: draw.numbers?[2]),
                  LottoNumber(number: draw.numbers?[3]),
                  LottoNumber(number: draw.numbers?[4]),
                  LottoNumber(number: draw.numbers?[5]),
                  Icon(Icons.add),
                  LottoNumber(number: draw.numbers?[6]),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
