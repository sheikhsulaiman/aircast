import 'package:flutter/material.dart';

class AppColors {
  // Primary Weather Colors
  static const Color sunnyYellow = Color(0xFFFFE142);
  static const Color cloudyBlue = Color(0xFF42C6FF);
  static const Color rainyPink = Color(0xFFFF64D4);

  // Text colors
  static const Color textBlack = Color(0xFF000000);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGray = Color(0xFF999999);

  // Background colors
  static const Color statsBackground = Color(0xFF1A1A1A);
  static const Color badgeGreen = Color(0xFF2D5F2E);
  static const Color appBackground = Color(0xFFFAFAFA);
  static const Color appBackgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Get card color based on weather description
  static Color getCardColor(String weatherDescription) {
    final description = weatherDescription.toLowerCase();

    if (description.contains('sun') || description.contains('clear')) {
      return sunnyYellow;
    } else if (description.contains('rain') || description.contains('storm')) {
      return rainyPink;
    } else {
      return cloudyBlue;
    }
  }
}
