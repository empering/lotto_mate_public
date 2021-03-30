import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lotto_mate/commons/app_colors.dart';

class AppIndicator extends StatelessWidget {
  final Color color;

  AppIndicator({this.color = AppColors.primary});

  @override
  Widget build(BuildContext context) {
    return SpinKitPulse(color: color);
  }
}
