import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class HourlyScreen extends StatefulWidget {
  final String city;
  final Function(String) onSearch;
  final Map<String, dynamic>? forecastData;
  final bool isLoading;

  const HourlyScreen({
    super.key,
    required this.city,
    required this.onSearch,
    this.forecastData,
    required this.isLoading,
  });

  @override
  State<HourlyScreen> createState() => _HourlyScreenState();
}

class _HourlyScreenState extends State<HourlyScreen> {
  int _selectedDayIndex = 0;

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
              widget.onSearch(value);
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
                widget.onSearch(controller.text);
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  // Helper to group forecasts by day
  List<List<dynamic>> _getGroupedForecasts() {
    if (widget.forecastData == null) return [];
    final list = widget.forecastData!['list'] as List;
    
    Map<String, List<dynamic>> grouped = {};
    for (var item in list) {
      final date = DateTime.parse(item['dt_txt']);
      // Using YYYY-MM-DD as key
      final dateKey = DateFormat('yyyy-MM-dd').format(date);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(item);
    }
    
    return grouped.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    final groupedForecasts = _getGroupedForecasts();
    
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.dashboardGradient,
      ),
      child: SafeArea(
        child: widget.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _showSearchDialog(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.city,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.darkText,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.search, size: 16),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (groupedForecasts.isNotEmpty) _buildDayTabs(groupedForecasts),
                  const SizedBox(height: 16),
                  _buildTableHeaders(),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  Expanded(
                    child: groupedForecasts.isNotEmpty
                        ? _buildHourlyList(groupedForecasts[_selectedDayIndex])
                        : const SizedBox(),
                  ),
                  const SizedBox(height: 100), // Padding for bottom nav
                ],
              ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 24),
            onPressed: () {},
          ),
          const Text(
            'Hourly',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkText,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined, size: 24),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDayTabs(List<List<dynamic>> groupedForecasts) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(groupedForecasts.length, (index) {
          final firstItemDate = DateTime.parse(groupedForecasts[index][0]['dt_txt']);
          final isToday = index == 0;
          final dayName = isToday ? 'Today' : DateFormat('E').format(firstItemDate); // e.g. Mon, Tue
          final dateName = DateFormat('MMM d').format(firstItemDate); // e.g. May 21
          
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDayIndex = index;
                });
              },
              child: _buildDayTab(dayName, dateName, _selectedDayIndex == index),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDayTab(String day, String date, bool isSelected) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            day,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.white : AppTheme.darkText,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          date,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? AppTheme.darkText : AppTheme.lightText,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeaders() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: const [
          Expanded(flex: 2, child: Text('TIME', style: _headerStyle)),
          Expanded(flex: 2, child: Text('WEATHER', style: _headerStyle)),
          Expanded(flex: 2, child: Text('TEMP.', style: _headerStyle, textAlign: TextAlign.center)),
          Expanded(flex: 3, child: Text('FEELS LIKE', style: _headerStyle, textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text('PRECIP.', style: _headerStyle, textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text('WIND', style: _headerStyle, textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  static const TextStyle _headerStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppTheme.lightText,
  );

  Widget _buildHourlyList(List<dynamic> dayForecasts) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: dayForecasts.length,
      separatorBuilder: (context, index) => const Divider(height: 24, color: Color(0xFFEEEEEE)),
      itemBuilder: (context, index) {
        final data = dayForecasts[index];
        final date = DateTime.parse(data['dt_txt']);
        final timeStr = DateFormat('h a').format(date);
        final temp = data['main']['temp'].round();
        final feelsLike = data['main']['feels_like'].round();
        final iconCode = data['weather'][0]['icon'];
        final pop = (data['pop'] * 100).round();
        final wind = data['wind']['speed'].toStringAsFixed(1);
        
        return Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                timeStr,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
            Expanded(
              flex: 2,
              child: Image.network('https://openweathermap.org/img/wn/$iconCode.png', width: 30, height: 30),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '$temp°',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                '$feelsLike°',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.lightText, fontSize: 14),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.water_drop_outlined, color: AppTheme.primaryBlue, size: 12),
                  const SizedBox(width: 2),
                  Text(
                    '$pop%',
                    style: const TextStyle(color: AppTheme.primaryBlue, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '$wind m/s',
                textAlign: TextAlign.right,
                style: const TextStyle(color: AppTheme.lightText, fontSize: 12, height: 1.2),
              ),
            ),
          ],
        );
      },
    );
  }
}
