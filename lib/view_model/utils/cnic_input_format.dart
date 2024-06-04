import 'package:flutter/services.dart';

/// CNIC Format Class
class CNICInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    final cleanText =
        text.replaceAll(RegExp(r'[^\d]'), ''); // Remove non-digits

    if (cleanText.isEmpty) {
      return TextEditingValue();
    }

    final formattedText = _formatCNIC(cleanText);

    if (formattedText.length > 15) {
      return TextEditingValue(
        text: formattedText.substring(0, 13),
        selection: TextSelection.collapsed(offset: 13),
      );
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _formatCNIC(String text) {
    final length = text.length;
    if (length <= 5) {
      // Format: 12345
      return text;
    } else if (length <= 12) {
      // Format: 12345-67890
      return '${text.substring(0, 5)}-${text.substring(5)}';
    } else {
      // Format: 12345-6789012-3
      return '${text.substring(0, 5)}-${text.substring(5, 12)}-${text.substring(12)}';
    }
  }
}
