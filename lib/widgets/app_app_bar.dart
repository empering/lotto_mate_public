import 'package:flutter/material.dart';
import 'package:lotto_mate/commons/app_colors.dart';

class AppAppBar extends AppBar {
  final String titleStr;

  AppAppBar(this.titleStr)
      : super(
          title: Text(
            titleStr,
            style: TextStyle(
              color: AppColors.primary,
            ),
          ),
          iconTheme: IconThemeData(
            color: AppColors.primary,
          ),
        );
}
