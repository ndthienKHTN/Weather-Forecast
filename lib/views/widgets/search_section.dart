import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_forecast/utils/validators/search_validator.dart';
import 'package:weather_forecast/viewmodels/weather_provider.dart';

class SearchSection extends StatefulWidget {
  final TextEditingController controller;

  const SearchSection({
    super.key,
    required this.controller,
  });

  @override
  State<SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  // Thêm biến để quản lý trạng thái validate
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter a city name',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                hintText: 'eg: London, Ho Chi Minh City',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                // Thêm errorText từ biến state
                errorText: _errorText,
              ),
              onChanged: (value) {
                // Reset error text khi người dùng gõ
                setState(() {
                  _errorText = null;
                });
              },
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Kiểm tra validate và cập nhật error text
                  final errorMessage =
                      SearchValidator.validateCityName(widget.controller.text);
                  setState(() {
                    _errorText = errorMessage;
                  });

                  if (errorMessage == null) {
                    context
                        .read<WeatherProvider>()
                        .fetchWeatherData(widget.controller.text);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[500],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Search',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Expanded(
                  child: Divider(
                    thickness: 1, // Độ dày của đường kẻ
                    color: Colors.grey, // Màu sắc của đường kẻ
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'or',
                    style: TextStyle(
                      color: Colors.grey, // Màu chữ
                      fontSize: 16, // Kích thước chữ
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context
                      .read<WeatherProvider>()
                      .fetchWeatherData('Ho Chi Minh');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
                child: const Center(
                  child: Text(
                    'Use current location',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
