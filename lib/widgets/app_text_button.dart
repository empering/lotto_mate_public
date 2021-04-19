import 'package:flutter/material.dart';
import 'package:lotto_mate/commons/app_colors.dart';

class AppTextButton extends StatelessWidget {
  final Color buttonColor;
  final Color labelColor;
  final IconData? labelIcon;
  final String? labelText;
  final VoidCallback? onPressed;
  final bool disabled;
  final bool isIconFirst;

  AppTextButton(
      {this.buttonColor = Colors.transparent,
      this.labelColor = AppColors.primary,
      this.labelIcon,
      this.labelText,
      this.onPressed,
      this.disabled = false,
      this.isIconFirst = true});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: disabled ? null : onPressed,
      style: TextButton.styleFrom(
        primary: disabled ? Colors.white : labelColor,
        backgroundColor: disabled ? Colors.white : buttonColor,
      ),
      child: Wrap(
        spacing: 10.0,
        children: _buildButtonLabel(),
      ),
    );
  }

  _buildButtonLabel() {
    var buttonLabel = <Widget>[];
    if (labelIcon != null && isIconFirst) {
      buttonLabel.add(Icon(labelIcon));
    }

    if (labelText != null) {
      buttonLabel.add(Text(labelText!));
    }

    if (labelIcon != null && !isIconFirst) {
      buttonLabel.add(Icon(labelIcon));
    }

    return buttonLabel;
  }
}
