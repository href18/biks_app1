import 'package:flutter/material.dart';

extension LoftetabellColor on String {
  Color toColor() {
    switch (this) {
      case 'fiolett':
        return Colors.purple;
      case 'grønn':
        return Colors.green;
      case 'gul':
        return Colors.yellow;
      case 'grå':
        return Colors.grey;
      case 'rød':
        return Colors.red;
      case 'brun':
        return Colors.brown;
      case 'blå':
        return Colors.blue;
      case 'oransje':
        return Colors.orange;
    }
    return Colors.black;
  }
}
