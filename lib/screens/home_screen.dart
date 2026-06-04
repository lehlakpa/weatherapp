import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  final String city;
  final Function(String) onSearch;
  final Map<String, dynamic>? weatherData;
  final Map<String, dynamic>? forecastData;
  final bool isLoading;

  const HomeScreen({
    super.key,
    required this.city,
    required this.onSearch,
    this.weatherData,
    this.forecastData,
    required this.isLoading,
  });

  void _showSearchDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search City'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter city name'),
            onSubmitted: (value) {
              Navigator.pop(context);
              onSearch(value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onSearch(controller.text);
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.dashboardGradient,
      ),
      child: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 32),
                    if (weatherData != null) _buildMainWeatherCircle(),
                    const SizedBox(height: 32),
                    if (weatherData != null) _buildWeatherDetailsRow(),
                    const SizedBox(height: 32),
                    _buildTodayForecastHeader(),
                    const SizedBox(height: 16),
                    if (forecastData != null) _buildTodayForecastList(),
                    const SizedBox(height: 100), // padding for bottom nav
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => _showSearchDialog(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              city,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkText,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.search, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMainWeatherCircle() {
    final temp = weatherData!['main']['temp'].round();
    final condition = weatherData!['weather'][0]['main'];
    final feelsLike = weatherData!['main']['feels_like'].round();
    final iconCode = weatherData!['weather'][0]['icon'];

    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.15),
            blurRadius: 40,
            spreadRadius: 10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            'https://openweathermap.org/img/wn/$iconCode@4x.png',
            width: 80,
            height: 80,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$temp',
                style: const TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkText,
                  height: 1.0,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  '°C',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.darkText,
                  ),
                ),
              ),
            ],
          ),
          Text(
            condition,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppTheme.darkText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Feels like $feelsLike°',
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetailsRow() {
    final humidity = weatherData!['main']['humidity'];
    final windSpeed = weatherData!['wind']['speed'];
    // UV index is not available in standard weather endpoint usually, defaulting to a mock
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildWeatherDetailItem(Icons.water_drop_outlined, '$humidity%', 'Humidity'),
        _buildWeatherDetailItem(Icons.air, '${windSpeed.toStringAsFixed(1)} m/s', 'Wind'),
        _buildWeatherDetailItem(Icons.wb_sunny_outlined, '5', 'UV Index'),
      ],
    );
  }

  Widget _buildWeatherDetailItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryBlue, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkText,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.lightText,
          ),
        ),
      ],
    );
  }

  Widget _buildTodayForecastHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Today\'s Forecast',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkText,
          ),
        ),
        const Text(
          'See all',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildTodayForecastList() {
    final list = forecastData!['list'] as List;
    // Take first 6 items for today's forecast approximation
    final todayForecasts = list.take(6).toList();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: todayForecasts.map((data) => _buildForecastItem(data)).toList(),
        ),
      ),
    );
  }

  Widget _buildForecastItem(dynamic data) {
    final date = DateTime.parse(data['dt_txt']);
    final timeStr = DateFormat('h a').format(date);
    final temp = data['main']['temp'].round();
    final condition = data['weather'][0]['main'];
    final iconCode = data['weather'][0]['icon'];
    final pop = (data['pop'] * 100).round(); // Probability of precipitation

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Text(
            timeStr,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkText,
            ),
          ),
          const SizedBox(height: 12),
          Image.network(
            'https://openweathermap.org/img/wn/$iconCode.png',
            width: 40,
            height: 40,
          ),
          const SizedBox(height: 4),
          Text(
            '$temp°',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            condition,
            style: const TextStyle(
              fontSize: 10,
              color: AppTheme.lightText,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.water_drop, color: AppTheme.primaryBlue, size: 12),
              const SizedBox(width: 2),
              Text(
                '$pop%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
