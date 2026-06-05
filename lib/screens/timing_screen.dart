import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
class TimingScreen extends StatefulWidget {
  const TimingScreen({super.key});

  @override
  State<TimingScreen> createState() => _TimingScreenState();
}

class _TimingScreenState extends State<TimingScreen> {
  late Timer _timer;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(DateTime time) {
    String hour = (time.hour % 12 == 0 ? 12 : time.hour % 12)
        .toString()
        .padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    String second = time.second.toString().padLeft(2, '0');
    String amPm = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute:$second $amPm';
  }

  String _formatDate(DateTime time) {
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    String month = months[time.month - 1];
    String dayName = days[time.weekday - 1];
    return '$dayName, $month ${time.day}, ${time.year}';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    final double iconSize = (screenWidth * 0.2).clamp(60.0, 120.0);
    final double timeFontSize = (screenWidth * 0.09).clamp(32.0, 80.0);
    final double dateFontSize = (screenWidth * 0.045).clamp(14.0, 28.0);
    final double containerWidth = (screenWidth * 0.85).clamp(280.0, 500.0);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.dashboardGradient,
        ),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                width: containerWidth,
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: iconSize,
                      color: AppTheme.primaryBlue,
                    ),
                    SizedBox(height: screenWidth * 0.05),
                    Text(
                      _formatTime(_currentTime),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.orbitron(
                        fontSize: timeFontSize,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkText,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.03),
                    Text(
                      _formatDate(_currentTime),
                      style: GoogleFonts.poppins(
                        fontSize: dateFontSize,
                        color: AppTheme.lightText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
