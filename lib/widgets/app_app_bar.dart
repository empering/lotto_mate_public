import 'package:flutter/material.dart';
import 'package:lotto_mate/commons/app_colors.dart';

class AppAppBar extends AppBar {
  final String titleStr;
  final PreferredSizeWidget? bottom;

  AppAppBar(this.titleStr, {this.bottom})
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
          bottom: bottom,
        );
}
