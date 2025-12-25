import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_colors.dart';
import '../providers/weather_provider.dart';

/// Screen that displays all forecast entries in a calendar view
class DetailedForecastScreen extends ConsumerWidget {
  final String city;

  const DetailedForecastScreen({super.key, required this.city});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecastAsync = ref.watch(forecastByCityProvider(city));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Forecast - $city',
          style: _textStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      backgroundColor: AppColors.appBackground,
      body: forecastAsync.when(
        data: (forecast) {
          final allForecasts = forecast.allForecasts;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: allForecasts.length,
            itemBuilder: (context, index) {
              final forecastDay = allForecasts[index];
              final date = forecastDay.date;
              final dateString = '${date.day}/${date.month}/${date.year}';
              final timeString =
                  '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

              // Check if this is a new day (compare with previous item)
              bool isNewDay = index == 0;
              if (index > 0) {
                final prevDate = allForecasts[index - 1].date;
                final prevDateKey =
                    '${prevDate.day}/${prevDate.month}/${prevDate.year}';
                final currentDateKey = dateString;
                isNewDay = prevDateKey != currentDateKey;
              }

              return Column(
                children: [
                  // Show divider and date label for new days
                  if (isNewDay && index > 0) ...[
                    const SizedBox(height: 12),
                    Divider(
                      color: AppColors.textGray.withOpacity(0.3),
                      thickness: 1.5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        _getDateLabel(date),
                        style: _textStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textGray,
                        ),
                      ),
                    ),
                  ],

                  // Forecast card
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.getCardColor(
                          forecastDay.description,
                        ).withAlpha(105),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Date and Time
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                dateString,
                                style: _textStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textBlack,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    CupertinoIcons.clock,
                                    size: 14,
                                    color: AppColors.textGray,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    timeString,
                                    style: _textStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textGray,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Weather condition and temperature
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                forecastDay.description,
                                style: _textStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textBlack,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _getWeatherIcon(forecastDay.description),
                                    color: AppColors.getCardColor(
                                      forecastDay.description,
                                    ),
                                    size: 24,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${forecastDay.temperature}°C',
                                    style: _textStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.getCardColor(
                                        forecastDay.description,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Additional info - Humidity and Wind
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${forecastDay.humidity}%',
                                style: _textStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textBlack,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(CupertinoIcons.wind),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Humidity',
                                    style: _textStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textGray,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
        loading: () {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.cloudyBlue),
            ),
          );
        },
        error: (error, stack) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error loading forecast',
                  style: _textStyle(
                    fontSize: 16,
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
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
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

  /// Get weather icon based on description
  IconData _getWeatherIcon(String description) {
    final desc = description.toLowerCase();

    if (desc.contains('sun') || desc.contains('clear')) {
      return Icons.wb_sunny;
    } else if (desc.contains('rain') || desc.contains('drizzle')) {
      return Icons.cloud_queue;
    } else if (desc.contains('storm') || desc.contains('thunderstorm')) {
      return Icons.flash_on;
    } else if (desc.contains('snow')) {
      return Icons.ac_unit;
    } else if (desc.contains('cloud')) {
      return Icons.wb_cloudy;
    } else if (desc.contains('wind')) {
      return Icons.air;
    } else if (desc.contains('fog') || desc.contains('mist')) {
      return Icons.cloud;
    } else {
      return Icons.wb_cloudy;
    }
  }

  /// Get formatted date label
  String _getDateLabel(DateTime date) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == DateTime(now.year, now.month, now.day)) {
      return 'Today';
    } else if (dateOnly == tomorrow) {
      return 'Tomorrow';
    } else if (dateOnly == yesterday) {
      return 'Yesterday';
    } else {
      final dayOfWeek = [
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
        'Sun',
      ][date.weekday - 1];
      return '$dayOfWeek, ${date.day}/${date.month}';
    }
  }
}
