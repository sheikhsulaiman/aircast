import 'package:aircast/models/weather_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_colors.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_card.dart';
import '../widgets/search_bar.dart';

class WeatherScreen extends ConsumerStatefulWidget {
  const WeatherScreen({super.key});

  @override
  ConsumerState<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> {
  late TextEditingController _searchController;
  bool _showSearch = false;

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
      ref.read(searchQueryProvider.notifier).state = query;
      setState(() {
        _showSearch = false;
      });
      _searchController.clear();
    }
  }

  void _toggleSearch() {
    setState(() => _showSearch = !_showSearch);
  }

  Color _getBackgroundColor(AsyncValue<Weather> weatherAsync) {
    try {
      return weatherAsync.when(
        data: (weather) => AppColors.getCardColor(weather.description),
        loading: () => AppColors.cloudyBlue,
        error: (_, __) => AppColors.rainyPink,
      );
    } catch (e) {
      return AppColors.cloudyBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the search query and weather provider
    final currentCity = ref.watch(searchQueryProvider);
    final weatherAsync = ref.watch(weatherByCityProvider(currentCity));

    return Scaffold(
      backgroundColor: _getBackgroundColor(weatherAsync),
      appBar: AppBar(
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOut),
                ),
                child: child,
              ),
            );
          },
          child: _showSearch
              ? SearchBar(
                  key: const ValueKey('search_bar'),
                  controller: _searchController,
                  onSearch: _searchWeather,
                  onClose: _toggleSearch,
                )
              : InkWell(
                  key: const ValueKey('city_title'),
                  onTap: _toggleSearch,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (currentCity.isEmpty ? 'Select City' : currentCity),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        CupertinoIcons.chevron_down,
                        color: AppColors.statsBackground,
                        size: 20,
                      ),
                    ],
                  ),
                ),
        ),
        backgroundColor: _getBackgroundColor(weatherAsync),
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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 64),
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
                    const SizedBox(height: 64),
                    ElevatedButton(
                      onPressed: _toggleSearch,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.textBlack,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _showSearch ? 'Close' : 'Search Again',
                        style: _textStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
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
}
