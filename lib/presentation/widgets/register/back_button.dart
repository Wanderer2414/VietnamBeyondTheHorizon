import 'package:flutter/material.dart';

class BackButton extends StatelessWidget {
  const BackButton({super.key, required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.height * 0.07,
      height: size.height * 0.1,
      alignment: Alignment.bottomRight,
      child: IconButton(
        onPressed: () {},
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          minimumSize: Size.square(size.height * 0.04),
          maximumSize: Size.square(size.height * 0.04),
          shape: CircleBorder(),
        ),
        icon: Icon(Icons.arrow_back_ios_rounded, size: size.height * 0.04),
      ),
    );
  }
}
