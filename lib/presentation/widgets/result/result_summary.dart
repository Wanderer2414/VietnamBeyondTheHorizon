import 'dart:ui';

import 'package:flutter/material.dart';

class ResultSummary extends StatelessWidget {
  final int missions;
  final int points;
  final double long;
  final int submited;
  const ResultSummary({
    super.key,
    required this.missions,
    required this.points,
    required this.long,
    required this.submited,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

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
          bottom: 0,
          left: 0,
          right: 0,
          height: 600,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/backgrounds/Vietnam map.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),

        Positioned(
          top: screenSize.height * 0.3,
          left: 10,
          right: 10,
          child: Container(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Text(
                      "Congratulation! \nYou passed all the missions",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Gantari",
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Here is the summary",
                    style: TextStyle(
                      fontFamily: "Gantari",
                      fontSize: 17,
                      fontWeight: FontWeight.w100,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 5),
                  resultBubble(missions.toString(), "Missions", 0),
                  SizedBox(height: 20),
                  resultBubble(points.toString(), "Points", 1),
                  // SizedBox(height: 20),
                  // resultBubble(long.toString(), "km long", 2),
                  SizedBox(height: 20),
                  resultBubble(submited.toString(), "photo submitted", 3),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Icon getIcon(int type) {
  switch (type) {
    case 0:
      return Icon(Icons.check_circle, size: 30, color: Colors.greenAccent);
    case 1:
      return Icon(Icons.star_rate_rounded, size: 30, color: Colors.yellow);
    case 2:
      return Icon(
        Icons.directions_walk_outlined,
        size: 30,
        color: const Color.fromARGB(255, 69, 204, 245),
      );
    case 3:
      return Icon(
        Icons.photo,
        size: 30,
        color: const Color.fromARGB(255, 241, 103, 93),
      );
    default:
      return Icon(Icons.add);
  }
}

Widget resultBubble(String value, String label, int type) {
  double radius = 50;
  return Stack(
    clipBehavior: Clip.none,
    children: [
      SizedBox(
        width: 300,
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
      Positioned(top: 14, left: 16, child: getIcon(type)),
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
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 105, 105, 105).withOpacity(0.1),
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
