class Weather {
  final String city;
  final String description;
  final double temperature;
  final String icon;
  final int humidity;
  final double windSpeed;
  final double visibility;

  Weather({
    required this.city,
    required this.description,
    required this.temperature,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.visibility,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'] ?? 'Unknown',
      description: json['weather'][0]['description'] ?? 'No description',
      temperature: (json['main']['temp'] ?? 0).toDouble(),
      icon: json['weather'][0]['icon'] ?? '01d',
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] ?? 0).toDouble(),
      visibility: ((json['visibility'] ?? 0) / 1000).toDouble(),
    );
  }

  @override
  String toString() =>
      'Weather(city: $city, temp: $temperature, desc: $description)';
}
