import 'package:flutter/services.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove all non-digit characters
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Format the text as MM-DD-YYYY
    if (newText.length >= 2) {
      newText = '${newText.substring(0, 2)}-${newText.length > 2 ? newText.substring(2) : ''}';
    }
    if (newText.length >= 5) {
      newText = '${newText.substring(0, 5)}-${newText.length > 5 ? newText.substring(5) : ''}';
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
