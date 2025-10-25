import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/heart_button.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/home_button.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/play_button.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/ranking_button.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/user_button.dart';

class HomeDownBar extends StatelessWidget {
  final Size size;
  const HomeDownBar({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final double spacing =
        (size.width - size.height * (5.0 / 3 + 0.7 + 0.4)) / 4;
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(),
      child: Stack(
        children: [
          CustomPaint(
            size: Size(size.width, size.height),
            painter: HomeDownBarDecoration(),
          ),
          Column(
            children: [
              SizedBox(height: size.height * 0.24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HomeButton(radius: size.height / 2),
                  SizedBox(width: spacing),
                  RankingButton(radius: size.height / 2 / 1.2),
                  SizedBox(width: spacing),
                  PlayButton(radius: size.height / 2 * 1.4),
                  SizedBox(width: spacing),
                  HeartButton(radius: size.height / 2 / 1.2),
                  SizedBox(width: spacing),
                  UserButton(radius: size.height / 2 / 1.2),
                  SizedBox(width: size.height / 24),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HomeDownBarDecoration extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Gradient gradient = LinearGradient(
      colors: [
        Color.fromARGB(255, 0xFA, 0x6C, 0x6F),
        Color.fromARGB(255, 0xD9, 0x91, 0),
      ],
      begin: AlignmentGeometry.xy(-2, 0.5),
      end: AlignmentGeometry.xy(1.8, 0.5),
    );
    final Paint paint = Paint()
      ..color = Colors.orange
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..style = PaintingStyle.fill;
    Path path = Path();
    // path.addOval(Rect.fromLTWH(0, 0, size.width, size.height));
    final double sideRadius = size.height / 4,
        middleRadius = sideRadius * 5 / 3,
        startY = size.height / 2;

    path.moveTo(sideRadius, startY);
    path.arcToPoint(
      Offset(sideRadius, size.height),
      radius: Radius.circular(sideRadius),
      clockwise: false,
    );
    path.lineTo(size.width - sideRadius, size.height);
    path.arcToPoint(
      Offset(size.width - sideRadius, startY),
      radius: Radius.circular(sideRadius),
      clockwise: false,
    );
    final double startX = sqrt(25 / 9 - 1 / 9) * sideRadius;
    path.lineTo(size.width / 2 + startX, startY);
    path.arcToPoint(
      Offset(size.width / 2 - startX, startY),
      radius: Radius.circular(middleRadius),
      clockwise: false,
    );
    path.lineTo(sideRadius * 2.2, startY);
    path.arcToPoint(
      Offset(sideRadius * 0.4, sideRadius * 0.4 + startY),
      radius: Radius.circular(sideRadius * 1.1),
      clockwise: false,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
