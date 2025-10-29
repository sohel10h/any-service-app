import 'package:flutter/material.dart';

class BottomNavBarNotchPainter extends CustomPainter {
  final Color color;
  final double notchRadius;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;
  final double shadowBlur;
  final Color shadowColor;

  BottomNavBarNotchPainter({
    required this.color,
    this.notchRadius = 22.0,
    this.borderRadius = 40.0,
    this.borderColor = const Color(0xFFE3E7EC),
    this.borderWidth = 1.0,
    this.shadowBlur = 10.0,
    this.shadowColor = const Color(0x1A000000),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // ✅ Draw main background shape
    final path = Path();

    // Top-left rounded corner
    path.moveTo(0, borderRadius);
    path.quadraticBezierTo(0, 0, borderRadius, 0);

    // Left straight line to notch start
    path.lineTo(centerX - notchRadius * 2, 0);

    // ✅ Half-moon notch under FAB
    path.arcToPoint(
      Offset(centerX + notchRadius * 2, 0),
      radius: Radius.circular(notchRadius * 2.1),
      clockwise: false,
    );

    // Top-right rounded corner
    path.lineTo(size.width - borderRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, borderRadius);

    // Bottom-right corner
    path.lineTo(size.width, size.height - borderRadius);
    path.quadraticBezierTo(size.width, size.height, size.width - borderRadius, size.height);

    // Bottom-left corner
    path.lineTo(borderRadius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - borderRadius);

    path.close();

    // ✅ Add shadow first (so it appears below)
    canvas.drawShadow(path, shadowColor, shadowBlur, true);

    // ✅ Fill background
    canvas.drawPath(path, paint);

    // ✅ Optional border
    if (borderWidth > 0) {
      final borderPaint = Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth;
      canvas.drawPath(path, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
