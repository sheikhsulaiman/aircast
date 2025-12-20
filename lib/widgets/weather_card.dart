import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/app_colors.dart';
import '../models/weather_model.dart';
import 'stats_card.dart';
import 'forecast_card.dart';
import 'date_badge.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final cardColor = AppColors.getCardColor(weather.description);
    final today = DateFormat('EEEE, d MMMM').format(DateTime.now());

    return Container(
      decoration: BoxDecoration(color: cardColor),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ========== DATE BADGE ==========
          Center(child: DateBadge(date: today)),

          const SizedBox(height: 16),

          // ========== TEMPERATURE ==========
          Center(
            child: Text(
              '${weather.temperature.toStringAsFixed(0)}°',
              style: _temperature(),
            ),
          ),

          const SizedBox(height: 24),

          // ========== WEATHER DESCRIPTION ==========
          Center(
            child: Text(weather.description, style: _bodyText(fontSize: 20)),
          ),
          const SizedBox(height: 24),

          // ========== DAILY SUMMARY ==========
          Text('Daily Summary', style: _heading3()),

          const SizedBox(height: 8),

          Text(
            'Now it seems that +20°, in fact +20°. It\'s humid now because of the heavy rain. Today, the temperature is fell in the range from +22° to +28°.',
            style: _bodyText(fontSize: 13),
          ),

          const SizedBox(height: 16),

          // ========== STATS CARD ==========
          StatsCard(
            windSpeed: weather.windSpeed,
            humidity: weather.humidity,
            visibility: weather.visibility,
          ),

          const SizedBox(height: 16),

          // ========== WEEKLY FORECAST ==========
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Weekly forecast', style: _heading3()),
              const Icon(
                Icons.arrow_forward,
                color: AppColors.textBlack,
                size: 20,
              ),
            ],
          ),

          const SizedBox(height: 12),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ForecastCard(day: '21 Jan', temp: 26),
                const SizedBox(width: 12),
                ForecastCard(day: '22 Jan', temp: 25),
                const SizedBox(width: 12),
                ForecastCard(day: '23 Jan', temp: 27),
                const SizedBox(width: 12),
                ForecastCard(day: '24 Jan', temp: 26),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _temperature() {
    return const TextStyle(
      fontFamily: 'SFCompactDisplay',
      fontSize: 96,
      fontWeight: FontWeight.bold,
      color: AppColors.textBlack,
      height: 1.0,
    );
  }

  TextStyle _heading3() {
    return const TextStyle(
      fontFamily: 'SFProText',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textBlack,
    );
  }

  TextStyle _bodyText({double fontSize = 16}) {
    return TextStyle(
      fontFamily: 'SFProText',
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: AppColors.textBlack,
    );
  }
}
