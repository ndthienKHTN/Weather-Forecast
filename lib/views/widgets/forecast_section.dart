import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:weather_forecast/models/weather_response.dart';
import 'package:weather_forecast/viewmodels/weather_provider.dart';

class ForecastSection extends StatelessWidget {
  final List<ForecastDay> forecastDays;

  const ForecastSection({
    super.key,
    required this.forecastDays,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dự báo thời tiết',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: forecastDays.length,
          itemBuilder: (context, index) {
            return _buildForecastDay(forecastDays[index]);
          },
        ),
        _buildLoadMoreButton(context),
      ],
    );
  }

  Widget _buildForecastDay(ForecastDay day) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[600],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              day.date,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          CachedNetworkImage(
            imageUrl: day.day.condition.icon,
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Temperature: ${day.day.avgtempC}°C',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'Wind: ${day.day.maxwindKph} KPH',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'Humidity: ${day.day.avghumidity}%',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreButton(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, child) {
        if (!weatherProvider.canLoadMore) {
          return const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 8),
          child: ElevatedButton(
            onPressed: weatherProvider.isLoading
                ? null
                : () => weatherProvider.loadMoreDays(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[500],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: weatherProvider.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Load more 4 days',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
