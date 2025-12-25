import 'package:aircast/models/forecast_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

/// Provider for WeatherService instance
/// This is a singleton - same instance used throughout the app
///
final weatherServiceProvider = Provider<WeatherService>((ref) {
  return WeatherService();
});

/// FutureProvider that fetches weather data
/// The String parameter is the city name
final weatherByCityProvider = FutureProvider.family<Weather, String>((
  ref,
  arg,
) async {
  String city = arg;
  final service = ref.watch(weatherServiceProvider);
  return service.getWeatherByCity(city);
});

/// The String parameter is the latitude and longitude in a Map
final weatherByCoordinatesProvider =
    FutureProvider.family<Weather, Map<String, String>>((ref, arg) async {
      String lat = arg['lat'] ?? '0';
      String lon = arg['lon'] ?? '0';
      final service = ref.watch(weatherServiceProvider);
      return service.getWeatherByCoordinates(lat, lon);
    });

/// NEW: 5-day forecast provider
/// Returns: Forecast object with all 40 entries + daily summaries
/// Watches: ref.watch(forecastByCityProvider('London'))
///
/// Each city is cached separately:
/// - ref.watch(forecastByCityProvider('London')) ← separate cache
/// - ref.watch(forecastByCityProvider('Paris'))  ← different cache
final forecastByCityProvider = FutureProvider.family<Forecast, String>((
  ref,
  city,
) async {
  final service = ref.watch(weatherServiceProvider);
  return service.getForecastByCity(city);
});

/// StateProvider for managing the search query
/// Holds the current city name being searched
final searchQueryProvider = StateProvider<String>((ref) => 'London');
