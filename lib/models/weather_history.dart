import 'package:weather_forecast/models/weather_response.dart';

class WeatherHistory {
  final String city;
  final DateTime searchTime;
  final WeatherResponse weatherData;

  WeatherHistory({
    required this.city,
    required this.searchTime,
    required this.weatherData,
  });
}
