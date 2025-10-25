import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  final double radius;
  const HomeButton({super.key, required this.radius});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.zero,
        minimumSize: Size.square(radius / 2),
        maximumSize: Size.square(radius),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      child: Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/icons/home.png"),
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
    );
  }
}
