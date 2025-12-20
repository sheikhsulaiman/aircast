import 'package:flutter/material.dart';
import '../config/app_colors.dart';

class ForecastCard extends StatelessWidget {
  final String day;
  final int temp;

  const ForecastCard({super.key, required this.day, required this.temp});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.textBlack, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '$temp°',
            style: const TextStyle(
              fontFamily: 'SFCompactDisplay',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 8),
          const Icon(Icons.cloud, color: AppColors.textBlack, size: 16),
          const SizedBox(height: 8),
          Text(
            day,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'SFProText',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textBlack,
            ),
          ),
        ],
      ),
    );
  }
}
