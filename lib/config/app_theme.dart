import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.appBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.appBackground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'SFProText',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textBlack,
        ),
        iconTheme: IconThemeData(color: AppColors.textBlack),
      ),
    );
  }
}
