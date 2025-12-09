import 'package:flutter/material.dart';

class BottomContent extends StatelessWidget {
  final String content;
  final Size size;
  final EdgeInsets padding;
  const BottomContent({
    super.key,
    required this.content,
    required this.size,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      padding: padding,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(shape: BoxShape.rectangle),
      alignment: Alignment.center,
      child: Text(
        content,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          color: Colors.black87,
          fontFamily: "Kay Pho Du",
        ),
      ),
    );
  }
}
