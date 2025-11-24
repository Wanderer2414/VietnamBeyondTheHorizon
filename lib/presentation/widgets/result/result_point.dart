import 'dart:ui';

import 'package:flutter/material.dart';

class ResultPagePoint extends StatelessWidget {
  final int points;

  const ResultPagePoint({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/backgrounds/Result screen.png"),
              fit: BoxFit.cover,
            ),

            // gradient: LinearGradient(
            //   colors: [Color(0xFFFFC78C), Color(0xFFFF8E53)],
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            // ),
          ),
        ),
        Positioned(
          bottom: -40,
          left: 0,
          right: 0,
          height: 300,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/backgrounds/Vietnam flag.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),

        Container(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "What a meaningful journey!",
                  style: TextStyle(
                    fontFamily: "Gantari",
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "You earned",
                  style: TextStyle(
                    fontFamily: "Gantari",
                    fontSize: 17,
                    fontWeight: FontWeight.w100,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 5),
                resultBubble(points.toString(), "Points"),

                SizedBox(height: 16),
                Text(
                  "Checking your points on the header bar",
                  style: TextStyle(
                    fontFamily: "Gantari",
                    fontSize: 15,
                    fontWeight: FontWeight.w100,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget resultBubble(String value, String label) {
  double radius = 50;
  return Stack(
    clipBehavior: Clip.none,
    children: [
      SizedBox(
        width: 260,
        child: gradientGlassBorder(
          radius: radius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: "Gantari",
                    fontSize: 19,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Positioned(
        top: 12,
        left: 16,
        child: Icon(Icons.star_rate_rounded, size: 30, color: Colors.yellow),
      ),
    ],
  );
}

Widget gradientGlassBorder({
  required Widget child,
  double width = 2,
  double radius = 40,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: Stack(
      children: [
        // Border gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF5E62), Color(0xFFFF8E53)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          padding: EdgeInsets.all(width),
        ),

        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 105, 105, 105).withOpacity(0.15),
              borderRadius: BorderRadius.circular(radius - width),
              border: BoxBorder.all(width: width, color: Color(0xFFFF8E53)),
            ),
            child: child,
          ),
        ),
      ],
    ),
  );
}
