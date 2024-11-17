import 'package:dio/dio.dart';
import '../models/weather_response.dart';

class WeatherService {
  final Dio _dio = Dio();
  final String _apiKey = '984ada41b98c49c9aa365847241411';
  final String _baseUrl = 'https://api.weatherapi.com/v1';

  Future<WeatherResponse> getWeather(String city, int days) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/forecast.json',
        queryParameters: {
          'key': _apiKey,
          'q': city,
          'days': days,
          'aqi': 'no',
          'alerts': 'no',
        },
        options: Options(
          followRedirects: true,
          validateStatus: (status) => status! < 500,
        ),
      );
      return WeatherResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Không thể lấy dữ liệu thời tiết: $e');
    }
  }
}
