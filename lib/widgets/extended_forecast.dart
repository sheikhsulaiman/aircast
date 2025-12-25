import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_colors.dart';
import '../providers/weather_provider.dart';
import '../screens/detailed_forecast_screen.dart';
import 'forecast_card.dart';

/// Widget that displays the weekly forecast
/// Uses real data from OpenWeatherMap API
class ExtendedForecast extends ConsumerWidget {
  final String city;

  const ExtendedForecast({super.key, required this.city});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the forecast provider for this city
    final forecastAsync = ref.watch(forecastByCityProvider(city));

    return forecastAsync.when(
      data: (forecast) {
        // Get daily summaries (1 entry per day)
        final dailySummaries = forecast.getDailySummaries();

        // Display next 7 days
        final displayForecasts = dailySummaries.take(7).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weekly Forecast',
                  style: _textStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailedForecastScreen(city: city),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.arrow_forward,
                    color: AppColors.textBlack,
                    size: 20,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Forecast cards in horizontal scroll
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < displayForecasts.length; i++) ...[
                    ForecastCard(forecastDay: displayForecasts[i]),
                    if (i < displayForecasts.length - 1)
                      const SizedBox(width: 12),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Debug info (remove in production)
            Text(
              'Total entries: ${forecast.allForecasts.length} | Days: ${displayForecasts.length}',
              style: _textStyle(
                fontSize: 10,
                color: AppColors.textGray,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        );
      },
      loading: () {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.appBackground,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.black.withOpacity(0.1), width: 1),
          ),
          child: SizedBox(
            height: 100,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.cloudyBlue),
              ),
            ),
          ),
        );
      },
      error: (error, stack) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.rainyPink.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.rainyPink, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Forecast Error',
                style: _textStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.rainyPink,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$error',
                style: _textStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.rainyPink,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  TextStyle _textStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.textBlack,
  }) {
    return TextStyle(
      fontFamily: 'SFProText',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
