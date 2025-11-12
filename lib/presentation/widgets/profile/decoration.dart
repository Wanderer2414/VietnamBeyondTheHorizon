import 'dart:math';

import 'package:flutter/material.dart';

class Decoration extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromCircle(
      center: Offset(size.width / 2, -size.width * 0.4),
      radius: size.width * 0.75,
    );
    final Gradient gradient = LinearGradient(
      colors: [Color(0xFFFFC371), Color(0xFFFF5F6D)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    final Paint paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawArc(rect, 0, pi, true, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
