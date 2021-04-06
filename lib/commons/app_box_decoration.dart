import 'package:flutter/material.dart';
import 'package:lotto_mate/commons/app_colors.dart';

class AppBoxDecoration {
  final Color color;
  final Color shdowColor;

  AppBoxDecoration({
    this.color = AppColors.backgroundLight,
    this.shdowColor = Colors.black38,
  });

  circular() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      color: color,
      boxShadow: [
        BoxShadow(
          color: shdowColor,
          blurRadius: 10.0,
        ),
      ],
    );
  }
}
