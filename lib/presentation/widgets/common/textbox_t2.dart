import 'package:flutter/material.dart';

class TextboxT2 extends StatelessWidget {
  final Size size;
  final String hint;
  const TextboxT2({super.key, required this.size, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: size.width * 0.8,
              height: size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: BoxBorder.all(width: 2, color: Colors.black38),
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hint: Text(
                    hint,
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                ),
                onTapOutside: (e) {
                  FocusScope.of(context).unfocus();
                  FocusScope.of(context).setFirstFocus(FocusScopeNode());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
