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
  static Color text757575 = colorFromHex('#757575');
  static Color text333333 = colorFromHex('#333333');
  static Color text181D27 = colorFromHex('#181D27');
  static Color text535862 = colorFromHex('#535862');
  static Color text414651 = colorFromHex('#414651');
  static Color text717680 = colorFromHex('#414651');
  static Color textF25B39 = colorFromHex('#F25B39');
  static Color text090A0A = colorFromHex('#090A0A');
  static Color containerB63B1F = colorFromHex('#B63B1F');
  static Color container4485FD = colorFromHex('#4485FD');
  static Color containerA584FF = colorFromHex('#A584FF');
  static Color containerFF7854 = colorFromHex('#FF7854');
  static Color containerFEA725 = colorFromHex('#FEA725');
  static Color container00CC6A = colorFromHex('#00CC6A');
  static Color container00C9E4 = colorFromHex('#00C9E4');
  static Color containerFD44B3 = colorFromHex('#FD44B3');
  static Color containerFD4444 = colorFromHex('#FD4444');
  static Color containerFAFAFA = colorFromHex('#FAFAFA');
  static Color borderE3E5E5 = colorFromHex('#E3E5E5');
  static Color borderE8E8E8 = colorFromHex('#E8E8E8');
  static Color borderD5D7DA = colorFromHex('#D5D7DA');
  static Color dividerE9EAEB = colorFromHex('#E9EAEB');
  static Color backgroundD4F1F9 = colorFromHex('#D4F1F9');

  static Color colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}
