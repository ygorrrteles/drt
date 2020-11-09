import 'package:flutter/material.dart';

class ColorFilterUtils {
  static Color idColorToColor(int id) {
    switch (id) {
      case 1:
        return Colors.white;
        break;
      case 2:
        return Colors.grey;
        break;
      case 3:
        return Colors.black;
        break;
      case 4:
        return Colors.red;
        break;
      default:
        return Colors.transparent;
        break;
    }
  }
}
