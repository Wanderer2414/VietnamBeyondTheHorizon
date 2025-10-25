import 'package:flutter/material.dart';

class StarsBox extends StatelessWidget {
  final Size size;
  const StarsBox({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width + size.height,
      height: size.height * 1.8,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  const BoxShadow(
                    color: Color(0xB2141414),
                    blurRadius: 5,
                    offset: Offset(-1, -1),
                    blurStyle: BlurStyle.inner,
                  ),
                  BoxShadow(
                    color: Color.alphaBlend(
                      Color.fromRGBO(0, 0, 0, 0.36),
                      Color.fromARGB(255, 0xFF, 0x95, 00),
                    ),
                    blurRadius: 2,
                    spreadRadius: -2.0,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft.add(
              AlignmentGeometry.xy(0, size.height * 0.05),
            ),
            child: Container(
              width: size.height * 1.5,
              height: size.height * 1.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/icons/star.png"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
