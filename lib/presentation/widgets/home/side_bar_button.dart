import 'package:flutter/material.dart';

class SideBarButton extends StatelessWidget {
  final double side;
  const SideBarButton({super.key, required this.side});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},

      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        minimumSize: Size.square(side),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
        ),
      ),
      child: Container(
        width: side,
        height: side,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/icons/bar.png")),
        ),
      ),
    );
  }
}
