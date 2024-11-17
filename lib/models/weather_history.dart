import 'package:weather_forecast/models/weather_response.dart';
import 'dart:convert';

class WeatherHistory {
  final String city;
  final DateTime searchTime;
  final WeatherResponse weatherData;

  WeatherHistory({
    required this.city,
    required this.searchTime,
    required this.weatherData,
  });

  factory WeatherHistory.fromJson(Map<String, dynamic> json) {
    return WeatherHistory(
      city: json['city'],
      searchTime: DateTime.parse(json['search_time']),
      weatherData: WeatherResponse.fromJson(jsonDecode(json['weather_data'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'search_time': searchTime.toIso8601String(),
      'weather_data': jsonEncode(weatherData.toJson()),
    };
  }
}
