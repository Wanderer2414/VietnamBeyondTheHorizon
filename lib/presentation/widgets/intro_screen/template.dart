import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/intro_screen/background.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/intro_screen/bottom_bar.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/intro_screen/bottom_content.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/intro_screen/shader_filter.dart';

class IntroScreenTemplate extends StatelessWidget {
  final int index, total;
  final Widget title;
  final String content;
  final ImageProvider background;
  final Route skipRoute, nextRoute;
  const IntroScreenTemplate({
    super.key,
    required this.index,
    required this.total,
    required this.title,
    required this.content,
    required this.background,
    required this.skipRoute,
    required this.nextRoute,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Background(screenSize: screenSize, background: background),
          ShadowFilter(),
          Column(
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
                    Container(
                      width: screenSize.width * 0.85,
                      height: screenSize.height * 0.17,
                      padding: EdgeInsets.only(top: screenSize.height * 0.03),
                      child: title,
                    ),
                    BottomContent(
                      content: content,
                      size: Size(
                        screenSize.width * 0.65,
                        screenSize.height * 0.2,
                      ),
                      padding: EdgeInsets.only(top: 20),
                    ),
                    Spacer(),
                    BottomBar(
                      index: index,
                      total: total,
                      context: context,
                      size: Size(screenSize.width, screenSize.height * 0.05),
                      skipRoute: skipRoute,
                      nextRoute: nextRoute,
                      padding: EdgeInsets.only(right: 10, left: 10, bottom: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
