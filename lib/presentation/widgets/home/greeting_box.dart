import 'package:flutter/material.dart';

class GreetingBox extends StatelessWidget {
  final Size size;
  final String userName;
  const GreetingBox({super.key, required this.size, required this.userName});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            blurStyle: BlurStyle.outer,
            blurRadius: 3,
            spreadRadius: 0,
            color: Color.fromRGBO(0, 0, 0, 0.5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsetsGeometry.only(top: 15, left: 20),
              child: Text(
                "Hi",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "KronaOne",
                  fontSize: 26,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsetsGeometry.only(bottom: 15, left: 20),
              child: Text(
                userName,
                maxLines: 1,
                softWrap: false,
                style: TextStyle(
                  color: Color.fromARGB(255, 0x1E, 0x17, 0x62),
                  fontFamily: "KronaOne",
                  fontSize: 26,
                  letterSpacing: -1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
