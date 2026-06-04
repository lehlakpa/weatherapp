import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class DailyScreen extends StatelessWidget {
  final String city;
  final Function(String) onSearch;
  final Map<String, dynamic>? forecastData;
  final bool isLoading;

  const DailyScreen({
    super.key,
    required this.city,
    required this.onSearch,
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

  List<Map<String, dynamic>> _getDailySummaries() {
    if (forecastData == null) return [];
    final list = forecastData!['list'] as List;
    
    Map<String, Map<String, dynamic>> dailyMap = {};
    
    for (var item in list) {
      final date = DateTime.parse(item['dt_txt']);
      final dateKey = DateFormat('yyyy-MM-dd').format(date);
      
      final temp = item['main']['temp'] as num;
      final pop = item['pop'] as num;
      final icon = item['weather'][0]['icon'];
      
      if (!dailyMap.containsKey(dateKey)) {
        dailyMap[dateKey] = {
          'date': date,
          'max': temp,
          'min': temp,
          'pop': pop,
          'icon': icon,
        };
      } else {
        if (temp > dailyMap[dateKey]!['max']) dailyMap[dateKey]!['max'] = temp;
        if (temp < dailyMap[dateKey]!['min']) dailyMap[dateKey]!['min'] = temp;
        if (pop > dailyMap[dateKey]!['pop']) dailyMap[dateKey]!['pop'] = pop;
        // Keep the daytime icon if possible, simple heuristic
        if (icon.contains('d')) {
          dailyMap[dateKey]!['icon'] = icon;
        }
      }
    }
    
    return dailyMap.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    final dailySummaries = _getDailySummaries();

    return Container(
      color: AppTheme.white,
      child: SafeArea(
        child: isLoading
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
                          city,
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
                  Expanded(
                    child: _buildDailyList(dailySummaries),
                  ),
                  _build15DayButton(),
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
            'Daily',
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

  Widget _buildDailyList(List<Map<String, dynamic>> dailySummaries) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      itemCount: dailySummaries.length,
      separatorBuilder: (context, index) => const Divider(height: 32, color: Color(0xFFEEEEEE)),
      itemBuilder: (context, index) {
        final data = dailySummaries[index];
        final date = data['date'] as DateTime;
        final isToday = index == 0;
        
        final dayStr = isToday ? 'Today' : DateFormat('E').format(date);
        final dateStr = DateFormat('MMM d').format(date);
        
        final maxStr = '${data['max'].round()}°';
        final minStr = '${data['min'].round()}°';
        final popStr = '${(data['pop'] * 100).round()}%';
        final iconCode = data['icon'];

        return Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dayStr,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateStr,
                    style: const TextStyle(color: AppTheme.lightText, fontSize: 12),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Image.network('https://openweathermap.org/img/wn/$iconCode.png', width: 40, height: 40),
            ),
            Expanded(
              flex: 2,
              child: Text(
                maxStr,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                minStr,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: AppTheme.primaryBlue),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.water_drop_outlined, color: AppTheme.primaryBlue, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    popStr,
                    style: const TextStyle(color: AppTheme.primaryBlue, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            const Icon(Icons.keyboard_arrow_down, color: AppTheme.lightText, size: 20),
          ],
        );
      },
    );
  }

  Widget _build15DayButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.primaryBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_month, color: AppTheme.primaryBlue, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Extended Forecast',
              style: TextStyle(
                color: AppTheme.primaryBlue,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
