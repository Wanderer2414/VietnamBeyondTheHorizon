import 'package:flutter/material.dart';

class ProfileFillLabel extends StatelessWidget {
  final Size size;
  const ProfileFillLabel({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      width: size.width,
      padding: EdgeInsets.only(left: size.width * 0.1, top: size.height * 0.1),
      alignment: Alignment.topLeft,
      child: Container(
        width: size.width * 0.7,
        height: size.height * 0.4,
        decoration: BoxDecoration(shape: BoxShape.rectangle),
        clipBehavior: Clip.hardEdge,
        child: Text(
          "Fill your profile",
          style: TextStyle(
            fontFamily: "InriaSans",
            fontSize: 50,
            fontWeight: FontWeight.w500,
            color: Color(0xFF795100),
          ),
        ),
      ),
    );
  }
}
