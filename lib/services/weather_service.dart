import 'package:dio/dio.dart';
import '../models/weather_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  final Dio _dio = Dio();
  final String _apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  WeatherService() {
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  /// Fetch weather by city name
  /// Example: getWeatherByCity('London')
  Future<Weather> getWeatherByCity(String city) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {'q': city, 'appid': _apiKey, 'units': 'metric'},
      );

      if (response.statusCode == 200) {
        return Weather.fromJson(response.data);
      } else {
        throw Exception('Failed to load weather data');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('City not found');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Connection timed out');
      } else {
        throw Exception('Failed to load weather data: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Fetch weather by coordinates
  /// Example: getWeatherByCoordinates(51.5074, -0.1278) for London
  Future<Weather> getWeatherByCoordinates(String lat, String lon) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': _apiKey,
          'units': 'metric',
        },
      );

      if (response.statusCode == 200) {
        return Weather.fromJson(response.data);
      } else {
        throw Exception('Failed to load weather data');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Locatin not found');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Connection timed out');
      } else {
        throw Exception('Failed to load weather data: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
