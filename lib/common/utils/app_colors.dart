import 'package:flutter/material.dart';

class AppColors {
  static Color primary = colorFromHex('#DC593B');
  static Color secondary = colorFromHex('#B63B1F');
  static Color scaffoldBackground = colorFromHex('#FFFFFF');
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color lightBlack = Colors.black45;
  static const Color blueGrey = Colors.blueGrey;
  static const Color red = Colors.red;
  static Color text9AA0B8 = colorFromHex('#9AA0B8');
  static Color text0C174B = colorFromHex('#0C174B');
  static Color text0D0140 = colorFromHex('#0D0140');
  static Color textCCD6DD = colorFromHex('#CCD6DD');
  static Color textA1A1A1 = colorFromHex('#A1A1A1');
  static Color text524B6B = colorFromHex('#524B6B');
  static Color textFF9228 = colorFromHex('#FF9228');
  static Color containerB63B1F = colorFromHex('#B63B1F');
  static Color borderE3E5E5 = colorFromHex('#E3E5E5');
  static Color borderE8E8E8 = colorFromHex('#E8E8E8');

  static Color colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}
