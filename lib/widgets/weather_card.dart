import 'package:aircast/widgets/extended_forecast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../config/app_colors.dart';
import '../models/weather_model.dart';
import 'stats_card.dart';
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

          Text(_getDailySummary(weather), style: _bodyText(fontSize: 13)),

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
      fontSize: 16,
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

  String _getDailySummary(Weather weather) {
    final temp = weather.temperature.toStringAsFixed(0);
    final feelsLike = weather.feelsLike.toStringAsFixed(0);
    final humidity = weather.humidity;
    final windSpeed = weather.windSpeed.toStringAsFixed(1);
    final description = weather.description.toLowerCase();

    // Build weather condition text
    String weatherCondition = '';
    if (description.contains('rain')) {
      weatherCondition = 'rainy weather with possible showers';
    } else if (description.contains('cloud')) {
      weatherCondition = 'cloudy skies throughout the day';
    } else if (description.contains('clear') || description.contains('sunny')) {
      weatherCondition = 'clear skies with sunshine';
    } else if (description.contains('snow')) {
      weatherCondition = 'snowy conditions';
    } else if (description.contains('storm')) {
      weatherCondition = 'stormy weather';
    } else {
      weatherCondition = 'variable weather';
    }

    // Build humidity description
    String humidityDesc = '';
    if (humidity > 80) {
      humidityDesc = 'very humid';
    } else if (humidity > 60) {
      humidityDesc = 'quite humid';
    } else if (humidity > 40) {
      humidityDesc = 'moderate humidity';
    } else {
      humidityDesc = 'dry conditions';
    }

    return 'Currently ${temp}° (feels like ${feelsLike}°). '
        'Expect ${weatherCondition} with ${humidityDesc} conditions (${humidity}% humidity). '
        'Wind speed: ${windSpeed} m/s.';
  }
}
