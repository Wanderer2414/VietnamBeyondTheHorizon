import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWrapper extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingWrapper({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [child, if (isLoading) const LoadingScreen()]);
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/backgrounds/loading_screen_1.png"),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.topCenter,

          child: Text(
            "Vietnam\n Beyond The Horizon",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontSize: 20,
              fontFamily: 'Gantari',
              fontWeight: FontWeight.w100,
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(15),
                width: 250,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(109, 143, 44, 14),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  getQuote(),
                  style: TextStyle(
                    color: Colors.yellow[100],
                    fontSize: 20,
                    fontFamily: 'Gantari',
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              SizedBox(width: 15),
              SpinKitFadingCircle(
                size: 80,
                itemBuilder: (_, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: index.isEven
                          ? const Color.fromARGB(126, 255, 117, 4)
                          : const Color.fromARGB(157, 255, 211, 13),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

String getQuote() {
  Random random = Random();
  int randnum = random.nextInt(3);
  switch (randnum) {
    case 1:
      return "The limit is not the sky. The limit is the mind.";
    case 2:
      return "Focus on the next step, not the whole path";
    case 3:
      return "Every second you wait, something gets better.";

    default:
      return "Enjoying the app? Rate us 5 stars to support future updates!";
  }
}
