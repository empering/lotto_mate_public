import 'package:flutter/material.dart';
import 'package:lotto_mate/commons/app_colors.dart';

class AppAppBar extends AppBar {
  final String titleStr;
  final Widget? widget;
  final PreferredSizeWidget? bottom;

  AppAppBar(this.titleStr, {this.widget, this.bottom})
      : super(
          title: widget == null
              ? Text(
                  titleStr,
                  style: TextStyle(
                    color: AppColors.primary,
                  ),
                )
              : Row(
                  children: [
                    widget,
                    SizedBox(width: 10),
                    Text(
                      titleStr,
                      style: TextStyle(
                        color: AppColors.primary,
                      ),
                    )
                  ],
                ),
          iconTheme: IconThemeData(
            color: AppColors.primary,
          ),
          bottom: bottom,
        );
}
