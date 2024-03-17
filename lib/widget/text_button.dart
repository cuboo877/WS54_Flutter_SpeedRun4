import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun4/constant/style_guide.dart';

class AppTextButton {
  static Widget customTextButton(
      Color backgroundColor, String text, int fontSize, onPressed) {
    return TextButton(
        style: TextButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        onPressed: onPressed,
        child: Text(text,
            style: TextStyle(
                color: AppColor.white, fontSize: fontSize.toDouble())));
  }

  static Widget outlineButton(Color backgroundColor, Color borderColor,
      String text, int fontSize, onPressed) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            backgroundColor: backgroundColor,
            side: BorderSide(color: borderColor, width: 2.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        onPressed: onPressed,
        child: Text(text,
            style:
                TextStyle(color: borderColor, fontSize: fontSize.toDouble())));
  }
}
