import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final ImageProvider background;
  const Background({
    super.key,
    required this.screenSize,
    required this.background,
  });

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: screenSize.width,
          height: screenSize.height,
          decoration: BoxDecoration(
            image: DecorationImage(image: background, fit: BoxFit.fill),
          ),
          child: null,
        ),
      ],
    );
  }
}
