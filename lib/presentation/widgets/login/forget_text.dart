import 'package:flutter/material.dart';

class ForgetBox extends StatelessWidget {
  final Size size;
  const ForgetBox({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      alignment: Alignment.topRight,
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          alignment: Alignment.topRight,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(5),
          ),
          minimumSize: Size(size.width * 0.30, size.height * 0.01),
          maximumSize: Size(size.width * 0.30, size.height),
        ),
        child: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "Forget password",
            style: TextStyle(
              fontSize: 40,
              fontFamily: "InriaSans",
              color: Color(0xFFEA7F38),
            ),
          ),
        ),
      ),
    );
  }
}
