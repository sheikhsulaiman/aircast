import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/app_colors.dart';
import '../models/forecast_model.dart'; // ADD THIS

class ForecastCard extends StatelessWidget {
  // Supports both old way (for backward compatibility) and new way (with real data)
  final String? day;
  final int? temp;
  final ForecastDay? forecastDay; // NEW: Real forecast data

  const ForecastCard({super.key, this.day, this.temp, this.forecastDay});

  @override
  Widget build(BuildContext context) {
    // Use forecast data if provided, otherwise use old values
    final displayDay = forecastDay != null
        ? DateFormat('d MMM').format(forecastDay!.date)
        : day ?? 'N/A';

    final displayTemp = forecastDay?.temperature ?? temp ?? 0;
    final description = forecastDay?.description ?? 'Clear';
    final humidity = forecastDay?.humidity ?? 0;

    return Container(
      width: 90,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.textBlack, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Temperature
          Text(
            '$displayTemp°',
            style: const TextStyle(
              fontFamily: 'SFCompactDisplay',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),

          const SizedBox(height: 6),

          // Weather icon based on OpenWeatherMap description
          _getWeatherIcon(description),

          const SizedBox(height: 6),

          // Date
          Text(
            displayDay,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'SFProText',
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: AppColors.textBlack,
            ),
          ),

          // Show humidity if forecast data available
          if (forecastDay != null) ...[
            const SizedBox(height: 4),
            Text(
              '$humidity%',
              style: const TextStyle(
                fontFamily: 'SFProText',
                fontSize: 9,
                fontWeight: FontWeight.w400,
                color: AppColors.textGray,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Get weather icon based on OpenWeatherMap description
  /// OpenWeatherMap descriptions:
  /// - Clear, Clouds, Rain, Drizzle, Thunderstorm
  /// - Snow, Mist, Smoke, Haze, Dust, Fog, Sand, Ash, Squall, Tornado
  Widget _getWeatherIcon(String description) {
    final desc = description.toLowerCase();

    if (desc.contains('rain') || desc.contains('drizzle')) {
      return const Icon(
        Icons.cloud_queue,
        color: AppColors.textBlack,
        size: 18,
      );
    } else if (desc.contains('cloud')) {
      return const Icon(Icons.wb_cloudy, color: AppColors.textBlack, size: 18);
    } else if (desc.contains('clear') || desc.contains('sunny')) {
      return const Icon(Icons.wb_sunny, color: AppColors.textBlack, size: 18);
    } else if (desc.contains('snow')) {
      return const Icon(Icons.ac_unit, color: AppColors.textBlack, size: 18);
    } else if (desc.contains('thunder') || desc.contains('storm')) {
      return const Icon(Icons.flash_on, color: AppColors.textBlack, size: 18);
    } else if (desc.contains('wind') ||
        desc.contains('tornado') ||
        desc.contains('squall')) {
      return const Icon(Icons.air, color: AppColors.textBlack, size: 18);
    } else if (desc.contains('mist') ||
        desc.contains('fog') ||
        desc.contains('haze')) {
      return const Icon(Icons.cloud, color: AppColors.textBlack, size: 18);
    } else {
      return const Icon(
        Icons.cloud_circle,
        color: AppColors.textBlack,
        size: 18,
      );
    }
  }
}
