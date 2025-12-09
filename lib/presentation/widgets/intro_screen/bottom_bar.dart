import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/intro_screen/next_button.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/intro_screen/screen_index.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/intro_screen/skip_button.dart';

class BottomBar extends Container {
  BottomBar({
    super.key,
    required int index,
    required int total,
    required BuildContext context,
    required Size size,
    required void Function() onSkip,
    required void Function() onNext,
    EdgeInsets padding = EdgeInsets.zero,
  }) : super(
         padding: padding,
         child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             SkipButton(onPressed: onSkip),
             CustomPaint(
               painter: ScreenIndex(index: index, total: total),
               size: Size(size.width * 0.15, size.height),
             ),
             NextButton(
               size: Size(size.width * 0.22, size.height),
               onPressed: onNext,
             ),
           ],
         ),
       );
}
