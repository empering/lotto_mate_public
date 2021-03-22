import 'package:flutter/material.dart';

class AppAppBar extends AppBar {
  final String titleStr;

  AppAppBar(this.titleStr)
      : super(
          title: Text(
            titleStr,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        );
}
