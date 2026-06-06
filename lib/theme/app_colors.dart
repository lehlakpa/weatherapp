import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color backgroundBlue = Color(0xFFE3F2FD);
  static const Color darkText = Color(0xFF1A1A1A);
  static const Color lightText = Color(0xFF757575);
  static const Color white = Colors.white;

  // Custom Status & Alert Colors
  static const Color success = Color(0xFF10B981);       // Modern Emerald Green
  static const Color error = Color(0xFFEF4444);         // Modern Rose Red
  static const Color warning = Color(0xFFF59E0B);       // Modern Amber Orange
  static const Color info = Color(0xFF3B82F6);          // Modern Sky Blue

  // Light tints for background of notifications (soft alerts)
  static const Color successLight = Color(0xFFECFDF5);
  static const Color errorLight = Color(0xFFFEF2F2);
  static const Color warningLight = Color(0xFFFFFBEB);
  static const Color infoLight = Color(0xFFEFF6FF);

  // Gradient Colors
  static const List<Color> dashboardGradient = [
    Color(0xFFD6E8FF),
    Color(0xFFF3F8FF),
  ];

  static const List<Color> errorGradient = [
    Color(0xFFFFECEC),
    Color(0xFFFFF5F5),
  ];

  static const List<Color> successGradient = [
    Color(0xFFE8FDF5),
    Color(0xFFF0FDF8),
  ];
}
