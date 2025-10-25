import 'dart:math';

import 'package:flutter/cupertino.dart';

class GemsBox extends StatelessWidget {
  final Size size;
  const GemsBox({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width + size.height / 2.3,
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
                    // offset: Offset(0, 3),
                    blurRadius: 2,
                    spreadRadius: -2.0,
                    // blurStyle: BlurStyle.outer,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft.add(
              AlignmentGeometry.xy(0, size.height * 0.03),
            ),
            child: Transform.rotate(
              angle: -pi / 4,
              origin: Offset(0, size.height / 2),
              child: Container(
                width: size.height * 1.5,
                height: size.height * 1.5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/icons/diamond-icon.png"),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
