import 'package:flutter/material.dart';

class AppColors {
  static Color primary = colorFromHex('#005AB3');
  static Color secondary = colorFromHex('#487ED2');
  static Color scaffoldBackground = colorFromHex('#FFFFFF');
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color lightBlack = Colors.black45;
  static const Color blueGrey = Colors.blueGrey;
  static const Color red = Colors.red;

  static Color colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}
