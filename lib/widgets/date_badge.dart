import 'package:flutter/material.dart';
import '../config/app_colors.dart';

class DateBadge extends StatelessWidget {
  final String date;

  const DateBadge({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.statsBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        date,
        style: const TextStyle(
          fontFamily: 'SFProText',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textWhite,
        ),
      ),
    );
  }
}
