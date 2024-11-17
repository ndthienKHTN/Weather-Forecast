import 'package:flutter/material.dart';
import 'package:weather_forecast/storage/database_helper.dart';
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

  // Thêm constructor để khởi tạo dữ liệu
  WeatherProvider() {
    loadSearchHistory();
  }

  // Cài đặt dữ liệu mặc định
  Future<void> initializeDefaultData() async {
    await fetchWeatherData('Ho Chi Minh');
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

  Future<void> loadSearchHistory() async {
    _searchHistory.clear();
    _searchHistory.addAll(await DatabaseHelper.instance.getHistoryForToday());
    notifyListeners();
  }

  void _addToHistory(String city, WeatherResponse data) async {
    final history = WeatherHistory(
      city: city,
      searchTime: DateTime.now(),
      weatherData: data,
    );

    // Lưu vào SQLite
    await DatabaseHelper.instance.insertHistory(history);
    // Xóa lịch sử cũ
    await DatabaseHelper.instance.deleteOldHistory();
    // Tải lại lịch sử
    await loadSearchHistory();
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
