import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun4/constant/style_guide.dart';

class Utilities {
  static void showSnackBar(BuildContext context, String content, int seconds) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: AppColor.black,
      content: Text(content),
      duration: Duration(seconds: seconds),
    ));
  }

  static String randomID() {
    Random random = Random();
    String result = "";
    for (int i = 0; i < 9; i++) {
      result += random.nextInt(9).toString();
    }
    return result;
  }

  static String randomPassword(bool hasLowerCase, bool hasUpperCase,
      bool hasSymbol, bool hasNumber, String customChars, int length) {
    StringBuffer buffer = StringBuffer();
    StringBuffer resultBuffer = StringBuffer();
    Random random = Random();
    if (hasLowerCase) {
      buffer.write("abcdefghijklmmopqrstuvwxyz");
    }
    if (hasUpperCase) {
      buffer.write("ABCDEFGHIJKLMNOPQRSTUVWXYZ");
    }
    if (hasSymbol) {
      buffer.write("!@#%^&*()_+{}?");
    }
    if (hasNumber) {
      buffer.write("0123456789");
    }

    for (int i = 0; i < length - customChars.length; i++) {
      resultBuffer.write(buffer.toString()[random.nextInt(buffer.length)]);
    }

    int index = random.nextInt(resultBuffer.length - 1);
    String result = resultBuffer.toString();
    return "${result.substring(0, index)}$customChars${result.substring(index)}";
  }
}
