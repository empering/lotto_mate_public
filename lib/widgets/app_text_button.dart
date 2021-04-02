import 'package:flutter/material.dart';
import 'package:lotto_mate/commons/app_colors.dart';

class AppTextButton extends StatelessWidget {
  final Color buttonColor;
  final Color labelColor;
  final IconData? labelIcon;
  final String? labelText;
  final VoidCallback? onPressed;
  final bool disabled;

  AppTextButton(
      {this.buttonColor = Colors.transparent,
      this.labelColor = AppColors.primary,
      this.labelIcon,
      this.labelText,
      this.onPressed,
      this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: disabled ? null : onPressed,
      style: TextButton.styleFrom(
        primary: disabled ? Colors.white : labelColor,
        backgroundColor: disabled ? Colors.white : buttonColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildButtonLabel(),
      ),
    );
  }

  _buildButtonLabel() {
    var buttonLabel = <Widget>[];
    if (labelIcon != null) {
      buttonLabel.add(Icon(labelIcon));
    }

    if (labelText != null) {
      buttonLabel.add(SizedBox(width: 5));
      buttonLabel.add(Text(labelText!));
    }

    return buttonLabel;
  }
}
