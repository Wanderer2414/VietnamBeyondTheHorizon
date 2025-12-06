import 'package:flutter/material.dart';

class ScreenIndex extends CustomPainter {
  final int index, total;
  const ScreenIndex({required this.index, required this.total});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.grey;
    final cpaint = Paint()..color = Colors.black;
    double width = size.width / total;
    for (int i = 0; i < total; i++) {
      if (i == index) {
        canvas.drawCircle(Offset(i * width, size.height * 0.5), 4, cpaint);
      } else {
        canvas.drawCircle(Offset(i * width, size.height * 0.5), 4, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
