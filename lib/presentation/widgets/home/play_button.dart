import 'package:flutter/material.dart';

class PlayButton extends StatelessWidget {
  final double radius;
  const PlayButton({super.key, required this.radius});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
        padding: WidgetStateProperty.resolveWith<EdgeInsets?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.pressed)) {
            return EdgeInsets.only(bottom: 3, top: 2);
          } else {
            return EdgeInsets.only(bottom: 5);
          }
        }),
        shape: WidgetStateProperty.all(CircleBorder()),
        fixedSize: WidgetStateProperty.all(Size(radius, radius)),
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        // shadowColor: WidgetStateProperty.all(Colors.black),
        shadowColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.pressed)) {
            return Colors.transparent;
          } else {
            return Colors.black;
          }
        }),
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
      ),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              spreadRadius: 2,
              offset: Offset(0, 2),
              color: Color(0x32000000),
            ),
          ],
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage("assets/icons/gamepad.png"),
            ),
          ),
        ),
      ),
    );
  }
}
