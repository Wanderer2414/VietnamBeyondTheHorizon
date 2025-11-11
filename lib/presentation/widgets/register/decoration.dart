import 'package:flutter/material.dart';

class Decoration extends StatelessWidget {
  const Decoration({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      alignment: Alignment.topCenter,
      child: CustomPaint(painter: GradientCircle(), size: size),
    );
  }
}

class GradientCircle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Gradient gradient1 = const LinearGradient(
      colors: [Color(0xFFEA7F38), Color(0xFFFFDF9E)],
      begin: AlignmentGeometry.xy(1.5, -1.5),
      end: AlignmentGeometry.xy(-1.2, 1.2),
    );
    final Paint paint1 = Paint()
      ..color = Colors.black
      ..shader = gradient1.createShader(
        Rect.fromLTWH(
          size.width * 0.9,
          size.height * 0.08,
          size.width * 0.3,
          size.width * 0.3,
        ),
      )
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.08),
      size.width * 0.3,
      paint1,
    );

    final Gradient gradient2 = const LinearGradient(
      colors: [Color(0xFFEA7F38), Color(0xFFFFDF9E)],
      begin: AlignmentGeometry.xy(-3, 0.4),
      end: AlignmentGeometry.xy(1, 0.1),
    );
    final Paint paint2 = Paint()
      ..color = Colors.black
      ..shader = gradient2.createShader(
        Rect.fromLTWH(
          -size.width * 0.2,
          size.height * 0.35,
          size.width * 0.44,
          size.width * 0.44,
        ),
      )
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(-size.width * 0.2, size.height * 0.35),
      size.width * 0.44,
      paint2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
