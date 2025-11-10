import 'package:flutter/material.dart';

class TransitionPageRoute extends PageRouteBuilder {
  TransitionPageRoute({
    required Widget nextScreen,
    required Offset begin,
    required Offset end,
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
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
  TransitionRLPageRoute({required super.nextScreen})
    : super(begin: Offset(1, 0), end: Offset.zero);
}
