import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class ApearAnimation extends PageRouteBuilder {
  ApearAnimation({required Widget nextScreen, super.opaque})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // return child;
          final positionAnimate =
              Tween<Offset>(begin: Offset(0, 0.15), end: Offset(0, 0)).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOutCubicEmphasized,
                ),
              );
          final scaleAnimate = Tween<double>(begin: 0.3, end: 1).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
          );

          final opacityAnimate = Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
          );

          final rotateAnimate = Tween<double>(begin: pi, end: 0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
          );
          return SlideTransition(
            position: positionAnimate,
            child: ScaleTransition(
              scale: scaleAnimate,
              child: FadeTransition(
                opacity: opacityAnimate,
                child: AnimatedBuilder(
                  animation: rotateAnimate,
                  builder: (context, child) {
                    var tilt = (animation.value - 0.5).abs() - 0.5;
                    tilt *= 0.003;
                    return Transform(
                      transform: Matrix4.rotationY(rotateAnimate.value)
                        ..setEntry(3, 0, tilt),
                      alignment: Alignment.center,
                      child: child,
                    );
                  },
                  child: child,
                ),
              ),
            ),
          );
        },
      );
}
