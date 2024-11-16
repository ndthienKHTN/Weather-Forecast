import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_forecast/viewmodels/weather_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blue[400]!, Colors.blue[300]!],
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.wb_sunny,
                        size: 40,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Weather Forecast',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Dự báo thời tiết',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              // Lịch sử tìm kiếm
              if (weatherProvider.searchHistory.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Lịch sử tìm kiếm',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...weatherProvider.searchHistory.map((history) => ListTile(
                      leading: const Icon(Icons.history),
                      title: Text(history.city),
                      subtitle: Text(
                        '${history.weatherData.current.tempC}°C - ${history.searchTime.hour}:${history.searchTime.minute}',
                      ),
                      onTap: () {
                        weatherProvider.loadFromHistory(history);
                        Navigator.pop(context); // Đóng drawer
                      },
                    )),
              ],
              const Divider(),
              // Các menu item khác
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Trang chủ'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.location_city),
                title: const Text('Thành phố mặc định'),
                subtitle: const Text('Vietnam'),
                onTap: () {
                  weatherProvider.initializeDefaultData();
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Thông tin'),
                onTap: () {
                  Navigator.pop(context);
                  showAboutDialog(
                    context: context,
                    applicationName: 'Weather Forecast',
                    applicationVersion: '1.0.0',
                    applicationIcon: const Icon(
                      Icons.wb_sunny,
                      size: 50,
                      color: Colors.orange,
                    ),
                    children: const [
                      Text('Ứng dụng dự báo thời tiết'),
                      SizedBox(height: 10),
                      Text('Powered by WeatherAPI.com'),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
