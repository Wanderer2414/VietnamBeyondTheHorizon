import 'package:flutter/material.dart';
import 'package:vietnam_beyond_the_horizon/widgets/intro_screen/next_button.dart';
import 'package:vietnam_beyond_the_horizon/widgets/intro_screen/screen_index.dart';
import 'package:vietnam_beyond_the_horizon/widgets/intro_screen/skip_button.dart';

class BottomBar extends Container {
  BottomBar({
    super.key,
    required int index,
    required int total,
    required BuildContext context,
    required Size size,
    required Route skipRoute,
    required Route nextRoute,
    EdgeInsets padding = EdgeInsets.zero,
  }) : super(
         padding: padding,
         child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             SkipButton(skipRoute: skipRoute),
             CustomPaint(
               painter: ScreenIndex(index: index, total: total),
               size: Size(size.width * 0.15, size.height),
             ),
             NextButton(
               nextRoute: nextRoute,
               size: Size(size.width * 0.22, size.height),
             ),
           ],
         ),
       );
}
