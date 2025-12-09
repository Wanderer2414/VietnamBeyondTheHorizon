import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/intro_screen/bottom_bar.dart';

class BottomBox extends StatelessWidget {
  const BottomBox({
    super.key,
    required this.screenSize,
    required this.content,
    required this.index,
    required this.total,
    required this.onNext,
    required this.onSkip,
  });

  final Size screenSize;
  final Widget content;
  final int index;
  final int total;
  final void Function() onSkip;
  final void Function() onNext;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: screenSize.width,
          height: screenSize.height * 0.45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 0,
            children: [
              content,
              Spacer(),
              BottomBar(
                index: index,
                total: total,
                context: context,
                size: Size(screenSize.width, screenSize.height * 0.05),
                onNext: onNext,
                onSkip: onSkip,
                padding: EdgeInsets.only(right: 10, left: 10, bottom: 10),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
