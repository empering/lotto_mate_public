import 'package:flutter/material.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';

class ColorStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar('색상별'),
      body: Center(
        child: Text('ColorStats'),
      ),
    );
  }
}
