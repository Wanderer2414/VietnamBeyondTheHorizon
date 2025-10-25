import 'package:flutter/material.dart';

class HomeDecoration extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Gradient gradient = LinearGradient(
      colors: [
        Color.fromARGB(255, 0xFC, 0xF7, 0xBB),
        Color.fromARGB(255, 0xFF, 0x62, 0x62),
      ],
      begin: AlignmentGeometry.xy(-1.5, -1),
      end: AlignmentGeometry.xy(4, 1),
    );
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = gradient.createShader(rect);
    final Paint shadowPaint = Paint()
      ..color = Color.fromARGB(255, 0xD9, 0x91, 0)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final double radius = size.width * 1.3;
    final Offset center = Offset(size.width / 2, size.height * 0.45 - radius);

    canvas.drawCircle(center, radius, paint);

    canvas.drawCircle(center, radius - 3, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
