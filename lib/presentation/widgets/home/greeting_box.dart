import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/avatar_circle_bound.dart';

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
      padding: EdgeInsets.only(
        left: size.width * 0.05,
        top: size.height * 0.15,
        bottom: size.height * 0.1,
      ),
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
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(left: size.width * 0.02),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: _TextGreeting(size: size, userName: userName),
            ),
          ),
          Spacer(),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: size.width * 0.1),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: AvaterCircle(radius: size.height * 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _TextGreeting extends StatelessWidget {
  final Size size;
  final String userName;
  const _TextGreeting({required this.size, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Hello, $userName",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Kay Pho Du",
            fontWeight: FontWeight.bold,
            fontSize: 38,
          ),
        ),
        SizedBox(
          width: size.width,
          height: size.height * 0.5,
          child: Row(
            children: [
              Icon(Icons.location_on, color: Color(0xFFCAC4D0)),
              Text(
                "Ho Chi Minh city",
                style: const TextStyle(
                  color: Color(0xFFCAC4D0),
                  fontFamily: "Kay Pho Du",
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
