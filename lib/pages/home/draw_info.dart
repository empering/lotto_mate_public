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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '✨',
              style:
                  Theme.of(context).textTheme.headline1!.copyWith(shadows: []),
            ),
            Text(
              '${draw.id}회',
              style: Theme.of(context).textTheme.headline1,
            ),
            Text(
              ' 당첨결과',
              style: Theme.of(context).textTheme.headline1,
            ),
            Text(
              '✨',
              style:
                  Theme.of(context).textTheme.headline1!.copyWith(shadows: []),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          '${draw.getDrawDateString()} 추첨',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.sub,
            fontSize: 24,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(15, 25, 15, 45),
          child: Column(
            children: [
              Text('당첨 번호'),
              SizedBox(height: 10),
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
