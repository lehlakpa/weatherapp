import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';
import 'home_screen.dart';
import 'hourly_screen.dart';
import 'timing_screen.dart';
import '../theme/app_theme.dart';
import '../services/weather_service.dart';
import '../services/error_handler.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  String _city = 'Kathmandu';
  final WeatherService _weatherService = WeatherService();

  Map<String, dynamic>? _currentWeather;
  Map<String, dynamic>? _forecastData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final weather = await _weatherService.getCurrentWeather(_city);
      final forecast = await _weatherService.getForecast(_city);

      setState(() {
        _currentWeather = weather;
        _forecastData = forecast;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ErrorHandler.showErrorNotification(context, e);
      }
    }
  }


  void _onCitySearched(String newCity) {
    if (newCity.isNotEmpty) {
      setState(() {
        _city = newCity;
      });
      _fetchWeatherData();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pass data down to screens
    final List<Widget> screens = [
      HomeScreen(
        city: _city,
        onSearch: _onCitySearched,
        weatherData: _currentWeather,
        forecastData: _forecastData,
        isLoading: _isLoading,
      ),
      const TimingScreen(),
      HourlyScreen(
        city: _city,
        onSearch: _onCitySearched,
        forecastData: _forecastData,
        isLoading: _isLoading,
      ),
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundBlue,
      body: Stack(
        children: [
          IndexedStack(index: _currentIndex, children: screens),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNav(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
