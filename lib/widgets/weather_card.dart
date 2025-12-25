import 'package:aircast/widgets/extended_forecast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../config/app_colors.dart';
import '../models/weather_model.dart';
import 'stats_card.dart';
import 'forecast_card.dart';
import 'date_badge.dart';

class WeatherCard extends ConsumerWidget {
  final Weather weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

          // NEW: Extended 6-day forecast (separate section)
          ExtendedForecast(city: weather.city),
        ],
      ),
    );
  }

  TextStyle _temperature() {
    return const TextStyle(
      fontFamily: 'SFCompactDisplay',
      fontSize: 120,
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
