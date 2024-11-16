import 'package:flutter/material.dart';
import '../models/weather_response.dart';
import '../services/weather_service.dart';
import '../models/weather_history.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  WeatherResponse? _weatherData;
  bool _isLoading = false;
  String? _error;
  int _currentDays = 4;
  bool _canLoadMore = true;

  // Thêm biến để lưu lịch sử
  final List<WeatherHistory> _searchHistory = [];

  WeatherResponse? get weatherData => _weatherData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get canLoadMore => _canLoadMore;
  List<WeatherHistory> get searchHistory => _searchHistory;

  // Cài đặt dữ liệu mặc định
  Future<void> initializeDefaultData() async {
    await fetchWeatherData('Vietnam');
  }

  Future<void> fetchWeatherData(String city) async {
    _isLoading = true;
    _error = null;
    _currentDays = 4;
    _canLoadMore = true;
    notifyListeners();

    try {
      final data = await _weatherService.getWeather(city, _currentDays);
      _weatherData = data;

      // Lưu vào lịch sử
      _addToHistory(city, data);

      _error = null;
    } catch (e) {
      _error = 'Không thể tìm thấy thông tin thời tiết: $e';
      _weatherData = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _addToHistory(String city, WeatherResponse data) {
    // Kiểm tra xem đã có trong ngày chưa
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Xóa lịch sử cũ hơn 1 ngày
    _searchHistory.removeWhere((item) {
      final itemDate = DateTime(
        item.searchTime.year,
        item.searchTime.month,
        item.searchTime.day,
      );
      return itemDate.isBefore(today);
    });

    // Thêm vào lịch sử
    _searchHistory.insert(
        0,
        WeatherHistory(
          city: city,
          searchTime: now,
          weatherData: data,
        ));

    notifyListeners();
  }

  void loadFromHistory(WeatherHistory history) {
    _weatherData = history.weatherData;
    _currentDays = 4;
    _canLoadMore = true;
    notifyListeners();
  }

  Future<void> loadMoreDays() async {
    if (!_canLoadMore || _weatherData == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newDays = _currentDays + 4;
      if (newDays > 10) {
        // API giới hạn 10 ngày
        _canLoadMore = false;
        return;
      }

      final data = await _weatherService.getWeather(
          _weatherData!.location.name, newDays);
      _currentDays = newDays;
      _weatherData = data;
    } catch (e) {
      _error = 'Không thể tải thêm dữ liệu: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
