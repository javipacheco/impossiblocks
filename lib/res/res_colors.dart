import 'package:flutter/material.dart';

class ResColors {

  static const Color primaryColorDark = Color(0xFF07315A);

  static const Color primaryColor = Color(0xff004ba0);

  static const Color colorTile1 = Color(0xff1976D2);

  static const Color colorTile2 = Color(0xffF57C00);

  static const Color boardBackground = Color(0xFFe0e0e0);

  static Color getAvatarColor(int color) {
    switch(color) {
      case 1: 
        return Colors.blue;
      break;
      case 2: 
        return Colors.pinkAccent;
      break;
      case 3: 
        return Colors.orange;
      break;
      case 4: 
        return Colors.green;
      break;
      case 5: 
        return Colors.purple;
      break;
      case 6: 
        return Colors.amber;
      break;
      case 7: 
        return Colors.cyan;
      break;
      default: 
        return Colors.red;
      break;
    }
  }
  
}
