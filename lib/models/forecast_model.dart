class ForecastDay {
  final int temperature;
  final int minTemp;
  final int maxTemp;
  final String description;
  final String icon;
  final DateTime date;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final int cloudiness;
  final double feelsLike;

  ForecastDay({
    required this.temperature,
    required this.minTemp,
    required this.maxTemp,
    required this.description,
    required this.icon,
    required this.date,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.cloudiness,
    required this.feelsLike,
  });

  /// Parse from OpenWeatherMap forecast API JSON
  /// Example structure:
  /// {
  ///   "dt": 1673740800,
  ///   "main": {
  ///     "temp": 10.5,
  ///     "feels_like": 9.2,
  ///     "temp_min": 8.2,
  ///     "temp_max": 12.3,
  ///     "humidity": 72,
  ///     "pressure": 1013
  ///   },
  ///   "weather": [
  ///     {
  ///       "main": "Clouds",
  ///       "description": "overcast clouds",
  ///       "icon": "04d"
  ///     }
  ///   ],
  ///   "wind": { "speed": 5.2 },
  ///   "clouds": { "all": 90 }
  /// }
  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      // Temperature (convert to int)
      temperature: (json['main']['temp'] as num?)?.toInt() ?? 0,
      minTemp: (json['main']['temp_min'] as num?)?.toInt() ?? 0,
      maxTemp: (json['main']['temp_max'] as num?)?.toInt() ?? 0,
      feelsLike: (json['main']['feels_like'] as num?)?.toDouble() ?? 0.0,

      // Weather description
      description: json['weather'][0]['main'] ?? 'Unknown',
      icon: json['weather'][0]['icon'] ?? '01d',

      // Date from Unix timestamp (multiply by 1000 for milliseconds)
      date: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),

      // Other details
      humidity: json['main']['humidity'] as int? ?? 0,
      windSpeed: (json['wind']['speed'] as num?)?.toDouble() ?? 0.0,
      pressure: json['main']['pressure'] as int? ?? 0,
      cloudiness: json['clouds']['all'] as int? ?? 0,
    );
  }

  @override
  String toString() =>
      'ForecastDay(date: $date, temp: $temperature°, desc: $description)';
}

/// Complete 5-day forecast from OpenWeatherMap
class Forecast {
  final String city;
  final String country;
  final List<ForecastDay> allForecasts; // All 40 entries (3-hour intervals)

  Forecast({
    required this.city,
    required this.country,
    required this.allForecasts,
  });

  /// Parse from OpenWeatherMap /forecast API response
  /// {
  ///   "city": {
  ///     "name": "London",
  ///     "country": "GB"
  ///   },
  ///   "list": [ ... 40 forecast entries ... ]
  /// }
  factory Forecast.fromJson(Map<String, dynamic> json) {
    final list = json['list'] as List? ?? [];

    return Forecast(
      city: json['city']['name'] ?? 'Unknown',
      country: json['city']['country'] ?? 'Unknown',
      allForecasts: list
          .map((item) => ForecastDay.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Get daily summaries (1 entry per day)
  ///
  /// OpenWeatherMap gives 8 entries per day (every 3 hours)
  /// This groups them into 1 per day by selecting the noon entry
  ///
  /// Strategy:
  /// 1. Group by date (year-month-day)
  /// 2. Prefer 12:00 noon entry
  /// 3. Fallback to 15:00 (3 PM) if available
  /// 4. Fallback to any entry for that day
  List<ForecastDay> getDailySummaries() {
    final Map<String, ForecastDay> dailyMap = {};

    // First pass: collect noon entries (12:00 hour)
    for (final forecast in allForecasts) {
      final dateKey = _getDateKey(forecast.date);

      if (forecast.date.hour == 12) {
        dailyMap[dateKey] = forecast;
      }
    }

    // Second pass: fill missing days with 15:00 (3 PM) entries
    for (final forecast in allForecasts) {
      final dateKey = _getDateKey(forecast.date);

      if (!dailyMap.containsKey(dateKey) && forecast.date.hour == 15) {
        dailyMap[dateKey] = forecast;
      }
    }

    // Third pass: fill remaining missing days with any entry
    for (final forecast in allForecasts) {
      final dateKey = _getDateKey(forecast.date);

      if (!dailyMap.containsKey(dateKey)) {
        dailyMap[dateKey] = forecast;
      }
    }

    // Return as sorted list (oldest to newest)
    final dailyList = dailyMap.values.toList();
    dailyList.sort((a, b) => a.date.compareTo(b.date));
    return dailyList;
  }

  /// Helper: Create date key (YYYY-MM-DD)
  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Get hourly forecast for a specific date
  /// Useful for showing hourly breakdown
  List<ForecastDay> getHourlyForDate(DateTime date) {
    final dateKey = _getDateKey(date);

    return allForecasts.where((forecast) {
      return _getDateKey(forecast.date) == dateKey;
    }).toList();
  }

  @override
  String toString() =>
      'Forecast(city: $city, entries: ${allForecasts.length}, days: ${getDailySummaries().length})';
}
