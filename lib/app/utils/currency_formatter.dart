import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyFormatter extends TextInputFormatter {
  final String locale;

  CurrencyFormatter({this.locale = 'id'});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remove all non-digit characters
    final newText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Parse the number
    final number = int.tryParse(newText) ?? 0;

    // Format the number with thousands separators
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: '',
      decimalDigits: 0,
    );
    final formattedText = formatter.format(number);

    // Maintain cursor position
    final cursorPosition = formattedText.length;

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}
