import 'package:flutter/material.dart';

class BarChart extends StatelessWidget {
  const BarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: const Size(200, 100),
        painter: BarChartPainter(),
      ),
    );
  }
}

class BarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    final bars = [
      Rect.fromLTWH(size.width * 0.1, size.height * 0.5, size.width * 0.15, size.height * 0.5),
      Rect.fromLTWH(size.width * 0.35, size.height * 0.3, size.width * 0.15, size.height * 0.7),
      Rect.fromLTWH(size.width * 0.6, size.height * 0.2, size.width * 0.15, size.height * 0.8),
      Rect.fromLTWH(size.width * 0.85, size.height * 0.6, size.width * 0.15, size.height * 0.4),
    ];

    for (final bar in bars) {
      canvas.drawRect(bar, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
