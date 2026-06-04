import 'package:flutter/material.dart';

class PainterProgressBar extends CustomPainter {
  final double value; // 0.0 → 1.0

  PainterProgressBar(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;

    final progressPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    // Background
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(10)),
      backgroundPaint,
    );

    // Progress
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width * value, size.height),
        const Radius.circular(10),
      ),
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant PainterProgressBar oldDelegate) {
    return oldDelegate.value != value;
  }
}
