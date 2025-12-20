import 'package:flutter/cupertino.dart';
import '../config/app_colors.dart';

class StatsCard extends StatelessWidget {
  final double windSpeed;
  final int humidity;
  final double visibility;

  const StatsCard({
    super.key,
    required this.windSpeed,
    required this.humidity,
    required this.visibility,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.statsBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            icon: CupertinoIcons.wind,
            label: 'Wind',
            value: '${windSpeed.toStringAsFixed(1)} m/s',
          ),
          _StatItem(
            icon: CupertinoIcons.drop,
            label: 'Humidity',
            value: '$humidity%',
          ),
          _StatItem(
            icon: CupertinoIcons.eye,
            label: 'Visibility',
            value: '${visibility.toStringAsFixed(1)} km',
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.textWhite, size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'SFProText',
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.textGray,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'SFProText',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textWhite,
          ),
        ),
      ],
    );
  }
}
