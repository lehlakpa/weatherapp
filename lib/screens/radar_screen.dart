import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_theme.dart';

class RadarScreen extends StatefulWidget {
  final String city;
  final Function(String) onSearch;

  const RadarScreen({
    super.key,
    required this.city,
    required this.onSearch,
  });

  @override
  State<RadarScreen> createState() => _RadarScreenState();
}

class _RadarScreenState extends State<RadarScreen> {
  double _timeSliderValue = 0.5;
  bool _isSatelliteMode = false;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white,
      child: SafeArea(
        child: Column(
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
            Expanded(
              child: Stack(
                children: [
                  _buildMap(),
                  _buildTimeSlider(),
                ],
              ),
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
            'Radar',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkText,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.layers_outlined, 
              size: 24, 
              color: _isSatelliteMode ? AppTheme.primaryBlue : AppTheme.darkText,
            ),
            onPressed: () {
              setState(() {
                _isSatelliteMode = !_isSatelliteMode;
              });
            },
            tooltip: 'Toggle Satellite Mode',
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: const LatLng(40.7128, -74.0060),
            initialZoom: 6,
          ),
          children: [
            TileLayer(
              urlTemplate: _isSatelliteMode 
                  ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
                  : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            // Mock Radar Overlay TileProvider would go here.
            // For now, we simulate radar visually with some map elements or simply the base map.
            MarkerLayer(
              markers: [
                Marker(
                  point: const LatLng(40.7128, -74.0060),
                  width: 120,
                  height: 80,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryBlue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.location_on, color: Colors.white, size: 16),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                        ),
                        child: Text(widget.city, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlider() {
    return Positioned(
      bottom: 24,
      left: 32,
      right: 32,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.play_arrow, color: AppTheme.darkText),
                const SizedBox(width: 8),
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 4,
                      activeTrackColor: AppTheme.primaryBlue,
                      inactiveTrackColor: Colors.grey.shade200,
                      thumbColor: AppTheme.primaryBlue,
                      overlayColor: AppTheme.primaryBlue.withOpacity(0.2),
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                    ),
                    child: Slider(
                      value: _timeSliderValue,
                      onChanged: (val) {
                        setState(() {
                          _timeSliderValue = val;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text('10:30 AM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('Now', style: TextStyle(color: AppTheme.lightText, fontSize: 10)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                gradient: const LinearGradient(
                  colors: [
                    Colors.lightGreenAccent,
                    Colors.green,
                    Colors.yellow,
                    Colors.orange,
                    Colors.red,
                    Colors.purple,
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Light', style: TextStyle(fontSize: 10, color: AppTheme.lightText)),
                Text('Moderate', style: TextStyle(fontSize: 10, color: AppTheme.lightText)),
                Text('Heavy', style: TextStyle(fontSize: 10, color: AppTheme.lightText)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
