import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/common/textbox_t1.dart';

class InputPanelT1 extends StatelessWidget {
  final Size size;
  final String content;
  final Function()? onTap;
  const InputPanelT1({
    super.key,
    required this.size,
    required this.content,
    this.onTap,
  });

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
            Padding(
              padding: EdgeInsetsGeometry.only(left: size.width * 0.03),
              child: Text(
                content,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: "InriaSans",
                  color: Color(0xFF747474),
                ),
              ),
            ),
            TextboxT1(
              size: Size(size.width * 0.8, size.height * 0.6),
              onTap: onTap,
            ),
          ],
        ),
      ),
    );
  }
}
