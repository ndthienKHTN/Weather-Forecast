import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_forecast/viewmodels/weather_provider.dart';
import 'package:weather_forecast/views/widgets/menu.dart';
import 'package:weather_forecast/views/widgets/search_section.dart';
import 'package:weather_forecast/views/widgets/weather_display.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().initializeDefaultData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[500],
        elevation: 0,
        title: const Text(
          'Weather Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AppDrawer(),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blue[100],
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchSection(controller: _cityController),
                    const WeatherDisplay(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}
