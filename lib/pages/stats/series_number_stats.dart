import 'package:flutter/material.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';

class SeriesNumberStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar('연속번호'),
      body: Center(
        child: Text('SeriesNumberStats'),
      ),
    );
  }
}
