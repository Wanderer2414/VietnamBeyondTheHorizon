import 'package:flutter/material.dart';

class RePasswordBox extends StatelessWidget {
  final Size size;
  const RePasswordBox({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsGeometry.only(left: size.width * 0.03),
              child: Text(
                "Confirm Password",
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: "InriaSans",
                  color: Color(0xFF747474),
                ),
              ),
            ),
            Container(
              width: size.width * 0.8,
              height: size.height * 0.6,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: BoxBorder.all(width: 2, color: Colors.black38),
              ),
              padding: EdgeInsets.only(bottom: 2, left: 10, right: 10),
              child: TextField(
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
