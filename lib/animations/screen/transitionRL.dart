import 'package:flutter/material.dart';

class TransitionPageRoute extends PageRouteBuilder {
  TransitionPageRoute({
    required Widget nextScreen,
    required Offset begin,
    required Offset end,
    Duration duration = const Duration(milliseconds: 300),
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
         transitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           final tween = Tween(
             begin: begin,
             end: end,
           ).chain(CurveTween(curve: Curves.ease));
           final drive = animation.drive(tween);
           return SlideTransition(position: drive, child: child);
         },
       );
}

class TransitionRLPageRoute extends TransitionPageRoute {
  TransitionRLPageRoute({required super.nextScreen, super.duration})
    : super(begin: Offset(2, 0), end: Offset.zero);
}

class TransitionLRPageRoute extends TransitionPageRoute {
  TransitionLRPageRoute({required super.nextScreen, super.duration})
    : super(begin: Offset(-2, 0), end: Offset.zero);
}

class TransitionBTPageRoute extends TransitionPageRoute {
  TransitionBTPageRoute({required super.nextScreen, super.duration})
    : super(begin: Offset(0, 2), end: Offset.zero);
}
