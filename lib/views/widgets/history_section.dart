import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/weather_provider.dart';
import 'package:intl/intl.dart';

class SearchHistory extends StatelessWidget {
  const SearchHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, child) {
        if (provider.searchHistory.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lịch sử tìm kiếm hôm nay',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: provider.searchHistory.length,
              itemBuilder: (context, index) {
                final history = provider.searchHistory[index];
                return Card(
                  child: ListTile(
                    title: Text(history.city),
                    subtitle: Text(
                      DateFormat('HH:mm').format(history.searchTime),
                    ),
                    trailing: Text(
                      '${history.weatherData.current.tempC}°C',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () => provider.loadFromHistory(history),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
