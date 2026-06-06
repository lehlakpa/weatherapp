import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_notification.dart';
import '../services/error_handler.dart';
import '../models/network_error.dart';

class PlaygroundScreen extends StatelessWidget {
  const PlaygroundScreen({super.key});

  void _triggerError(BuildContext context, NetworkException exception) {
    try {
      throw exception;
    } catch (e) {
      ErrorHandler.showErrorNotification(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.dashboardGradient,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Text(
                'Playground',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Test custom notifications, error handling & colors',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.lightText,
                ),
              ),
              const SizedBox(height: 24),
              
              // Custom Color Palette Section
              _buildSectionTitle('Custom Color Palette'),
              const SizedBox(height: 12),
              _buildColorsRow(),
              const SizedBox(height: 28),

              // Notifications Demo
              _buildSectionTitle('Custom Notifications'),
              const SizedBox(height: 12),
              _buildCard(
                children: [
                  _buildDemoButton(
                    context,
                    label: 'Success Notification',
                    icon: Icons.check_circle_rounded,
                    color: AppColors.success,
                    onPressed: () {
                      CustomNotification.showSuccess(
                        context,
                        'Weather details refreshed successfully!',
                        title: 'Refresh Success',
                      );
                    },
                  ),
                  const Divider(height: 16),
                  _buildDemoButton(
                    context,
                    label: 'Info Notification',
                    icon: Icons.info_rounded,
                    color: AppColors.info,
                    onPressed: () {
                      CustomNotification.showInfo(
                        context,
                        'A new update is available. Download from store.',
                        title: 'App Update',
                      );
                    },
                  ),
                  const Divider(height: 16),
                  _buildDemoButton(
                    context,
                    label: 'Warning Notification',
                    icon: Icons.warning_rounded,
                    color: AppColors.warning,
                    onPressed: () {
                      CustomNotification.showWarning(
                        context,
                        'GPS signal is weak. Location accuracy may vary.',
                        title: 'GPS Warning',
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Error Handling Demo
              _buildSectionTitle('Custom Error Handling'),
              const SizedBox(height: 12),
              _buildCard(
                children: [
                  _buildDemoButton(
                    context,
                    label: 'No Internet (SocketException)',
                    icon: Icons.wifi_off_rounded,
                    color: AppColors.error,
                    onPressed: () => _triggerError(context, ConnectionException()),
                  ),
                  const Divider(height: 16),
                  _buildDemoButton(
                    context,
                    label: 'Connection Timeout',
                    icon: Icons.timer_off_rounded,
                    color: AppColors.error,
                    onPressed: () => _triggerError(context, TimeoutException()),
                  ),
                  const Divider(height: 16),
                  _buildDemoButton(
                    context,
                    label: 'City Not Found (404)',
                    icon: Icons.location_off_rounded,
                    color: AppColors.error,
                    onPressed: () => _triggerError(
                      context,
                      NotFoundException(statusCode: 404),
                    ),
                  ),
                  const Divider(height: 16),
                  _buildDemoButton(
                    context,
                    label: 'Invalid API Key (401)',
                    icon: Icons.vpn_key_off_rounded,
                    color: AppColors.error,
                    onPressed: () => _triggerError(
                      context,
                      UnauthorizedException(statusCode: 401),
                    ),
                  ),
                  const Divider(height: 16),
                  _buildDemoButton(
                    context,
                    label: 'Internal Server Error (500)',
                    icon: Icons.dns_rounded,
                    color: AppColors.error,
                    onPressed: () => _triggerError(
                      context,
                      ServerException(statusCode: 500),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 120), // Padding for bottom navigation
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.darkText,
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildDemoButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkText,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.lightText.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorsRow() {
    return Row(
      children: [
        _buildColorIndicator('Success', AppColors.success, AppColors.successLight),
        const SizedBox(width: 12),
        _buildColorIndicator('Error', AppColors.error, AppColors.errorLight),
        const SizedBox(width: 12),
        _buildColorIndicator('Warning', AppColors.warning, AppColors.warningLight),
        const SizedBox(width: 12),
        _buildColorIndicator('Info', AppColors.info, AppColors.infoLight),
      ],
    );
  }

  Widget _buildColorIndicator(String name, Color color, Color lightColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: lightColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
        ),
        child: Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              name,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
