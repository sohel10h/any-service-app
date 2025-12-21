import 'package:flutter/services.dart';

class CustomDecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;

  CustomDecimalTextInputFormatter({required this.decimalRange}) : assert(decimalRange > 0);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    if (text.contains('.') && text.substring(text.indexOf('.') + 1).length > decimalRange) {
      return oldValue;
    }
    return newValue;
  }
}
