import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final ImageProvider background;
  const Background({
    super.key,
    required this.screenSize,
    required this.background,
    required this.scale,
  });

  final double scale;
  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenSize.width,
      height: screenSize.height,
      color: Colors.white,
      alignment: Alignment.center,
      child: Container(
        width: screenSize.width * scale,
        height: screenSize.height * scale,
        decoration: BoxDecoration(
          image: DecorationImage(image: background, fit: BoxFit.fill),
        ),
      ),
    );
  }
}
