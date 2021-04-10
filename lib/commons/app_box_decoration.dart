import 'package:flutter/material.dart';
import 'package:lotto_mate/commons/app_colors.dart';

class AppBoxDecoration {
  final Color color;
  final Color shdowColor;
  final double blurRadius;
  final Offset offset;

  AppBoxDecoration({
    this.color = AppColors.backgroundLight,
    this.shdowColor = Colors.black38,
    this.blurRadius = 10.0,
    this.offset = Offset.zero,
  });

  circular() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      color: color,
      boxShadow: [
        BoxShadow(
          color: shdowColor,
          blurRadius: blurRadius,
          offset: offset,
        ),
      ],
    );
  }
}
