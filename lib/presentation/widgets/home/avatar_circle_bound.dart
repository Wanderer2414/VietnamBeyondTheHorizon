import 'package:flutter/material.dart';

class AvaterCircle extends StatelessWidget {
  final double radius;
  const AvaterCircle({super.key, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(blurRadius: 1, color: Colors.black, spreadRadius: 1),
        ],
      ),
    );
  }
}
