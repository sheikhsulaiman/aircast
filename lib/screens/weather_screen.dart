import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_colors.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_card.dart';

class WeatherScreen extends ConsumerStatefulWidget {
  const WeatherScreen({super.key});

  @override
  ConsumerState<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> {
  late TextEditingController _searchController;
  String _currentCity = 'London';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchWeather() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      setState(() => _currentCity = query);
      _searchController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the weather provider with current city
    final weatherAsync = ref.watch(weatherByCityProvider(_currentCity));

    return Scaffold(
      backgroundColor: weatherAsync.value != null
          ? AppColors.getCardColor(weatherAsync.value!.description)
          : AppColors.cloudyBlue,
      appBar: AppBar(
        title: Text(
          (weatherAsync.value?.city ?? 'Air Cast'),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'SFProText',
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
        backgroundColor: AppColors.getCardColor(
          weatherAsync.value?.description ?? '',
        ),
      ),
      body: SingleChildScrollView(
        child: weatherAsync.when(
          data: (weather) {
            return WeatherCard(weather: weather);
          },
          loading: () {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(48.0),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.cloudyBlue,
                  ),
                ),
              ),
            );
          },
          error: (error, stack) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.rainyPink,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.textWhite,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error',
                    style: _textStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textWhite,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: _textStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textWhite,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            style: _textStyle(fontSize: 16, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              hintText: 'Search city...',
              hintStyle: _textStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textGray,
              ),
              prefixIcon: const Icon(
                Icons.location_on,
                color: AppColors.textBlack,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.textBlack,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.textBlack,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.cloudyBlue,
                  width: 2,
                ),
              ),
            ),
            onSubmitted: (_) => _searchWeather(),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: _searchWeather,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cloudyBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.search,
              color: AppColors.textWhite,
              size: 24,
            ),
          ),
        ),
      ],
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
