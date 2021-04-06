import 'package:flutter/material.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';

class UnpickNumberStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar('미출현번호'),
      body: Center(
        child: Text('UnpickNumberStats'),
      ),
    );
  }
}
