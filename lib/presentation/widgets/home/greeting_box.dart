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
      margin: EdgeInsets.zero,
      padding: EdgeInsets.only(left: size.width * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurStyle: BlurStyle.outer,
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x78000000),
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Hi",
              style: TextStyle(
                color: Colors.black,
                fontFamily: "KronaOne",
                fontSize: 26,
              ),
            ),

            Text(
              userName,
              maxLines: 1,
              softWrap: false,
              style: const TextStyle(
                color: Color(0xFF1E1762),
                fontFamily: "KronaOne",
                fontSize: 26,
                letterSpacing: -1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
