import 'package:flutter/material.dart';
import 'package:lotto_mate/commons/app_colors.dart';

class AppCircleIconButton extends StatelessWidget {
  final Color backgroundColor;
  final Color iconColor;
  final Icon icon;
  final double iconSize;
  final double? splashRadius;
  final Color splashColor;
  final VoidCallback onPressed;

  AppCircleIconButton(
      {this.backgroundColor = Colors.transparent,
      this.iconColor = AppColors.primary,
      this.iconSize = 24.0,
      this.splashRadius,
      this.splashColor = Colors.transparent,
      required this.icon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: ShapeDecoration(
        shape: CircleBorder(),
        color: backgroundColor,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        iconSize: this.iconSize,
        color: iconColor,
        splashColor: splashColor,
        splashRadius: splashRadius,
      ),
    );
  }
}
