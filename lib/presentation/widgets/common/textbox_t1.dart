import 'package:flutter/material.dart';

class TextboxT1 extends StatelessWidget {
  final Size size;
  final Function()? onTap;
  final TextEditingController controller;
  const TextboxT1({
    super.key,
    required this.size,
    this.onTap,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: BoxBorder.all(width: 2, color: Colors.black38),
      ),
      padding: EdgeInsets.only(bottom: 2, left: 10, right: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(border: InputBorder.none),
        onTapOutside: (e) {
          FocusScope.of(context).unfocus();
          FocusScope.of(context).setFirstFocus(FocusScopeNode());
        },
        onTap: onTap,
      ),
    );
  }
}
