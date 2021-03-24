import 'package:flutter/material.dart';
import 'package:lotto_mate/commons/app_colors.dart';

class AppCircleIconButton extends StatelessWidget {
  final Color backgroundColor;
  final Color iconColor;
  final Icon icon;
  final VoidCallback onPressed;

  AppCircleIconButton(
      {this.backgroundColor = Colors.transparent,
      this.iconColor = AppColors.primary,
      required this.icon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: iconColor,
        splashColor: backgroundColor,
      ),
    );
  }
}
