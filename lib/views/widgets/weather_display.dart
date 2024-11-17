import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_forecast/viewmodels/weather_provider.dart';
import 'current_weather.dart';
import 'forecast_section.dart';

class WeatherDisplay extends StatelessWidget {
  const WeatherDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (weatherProvider.isLoading &&
                    weatherProvider.weatherData == null)
                  const Center(child: CircularProgressIndicator())
                else if (weatherProvider.error != null)
                  Center(
                    child: Text(
                      weatherProvider.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                else if (weatherProvider.weatherData != null) ...[
                  CurrentWeather(weatherData: weatherProvider.weatherData!),
                  const SizedBox(height: 20),
                  ForecastSection(
                    forecastDays:
                        weatherProvider.weatherData!.forecast.forecastday,
                  ),
                  const SizedBox(height: 20),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
