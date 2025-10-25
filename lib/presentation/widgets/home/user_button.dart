import 'package:flutter/material.dart';

class UserButton extends StatelessWidget {
  final double radius;
  const UserButton({super.key, required this.radius});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        minimumSize: Size.square(radius / 2),
        maximumSize: Size.square(radius),
        padding: EdgeInsets.zero,
      ),

      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/icons/user.png")),
        ),
      ),
    );
  }
}
