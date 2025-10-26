import 'package:flutter/material.dart';

class HomeDecoration extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Gradient gradient = const LinearGradient(
      colors: [Color(0xFFFCF7BB), Color(0xFFFF6262)],
      begin: AlignmentGeometry.xy(-1.5, -1),
      end: AlignmentGeometry.xy(4, 1),
    );
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = gradient.createShader(rect);
    final Paint shadowPaint = Paint()
      ..color = const Color(0xFFD99100)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6)
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
