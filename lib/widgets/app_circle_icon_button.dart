import 'package:flutter/material.dart';

class AppCircleIconButton extends StatelessWidget {
  final Color backgroundColor;
  final Color iconColor;
  final Icon icon;
  final VoidCallback onPressed;

  AppCircleIconButton(
      {this.backgroundColor = Colors.indigoAccent,
      this.iconColor = Colors.white,
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
