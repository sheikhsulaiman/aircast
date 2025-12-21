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

  @override
  Widget build(BuildContext context) {
    // Watch the search query and weather provider
    final currentCity = ref.watch(searchQueryProvider);
    final weatherAsync = ref.watch(weatherByCityProvider(currentCity));

    return Scaffold(
      backgroundColor: weatherAsync.value != null
          ? AppColors.getCardColor(weatherAsync.value!.description)
          : AppColors.cloudyBlue,
      appBar: AppBar(
        title: _showSearch
            ? SearchBar(
                controller: _searchController,
                onSearch: _searchWeather,
                onClose: _toggleSearch,
              )
            : InkWell(
                onTap: _toggleSearch,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      (weatherAsync.value?.city ?? 'Air Cast'),
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
