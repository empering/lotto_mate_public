import 'package:flutter/material.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';

class EvenOddStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar('홀짝'),
      body: Center(
        child: Text('NumberStats'),
      ),
    );
  }
}
