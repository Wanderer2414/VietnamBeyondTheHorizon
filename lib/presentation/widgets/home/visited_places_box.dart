import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/data/packages/reccommend_scenic.dart';

import 'package:vietnambeyondthehorizon/presentation/widgets/home/scenic_panel.dart'
    as home_widgets;

class VisitedPlaceBox extends StatelessWidget {
  final Size size;
  const VisitedPlaceBox({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    ScrollController scrollbar = ScrollController();
    return Container(
      width: size.width,
      height: size.height,
      alignment: Alignment.topCenter,
      child: Scrollbar(
        controller: scrollbar,
        child: SingleChildScrollView(
          controller: scrollbar,
          scrollDirection: Axis.horizontal,
          child: Container(
            height: size.height,
            padding: EdgeInsets.all(5),
            child: Row(
              spacing: 10,
              children: List.generate(10, (index) {
                return home_widgets.ScenicPanel(
                  size: Size(size.width * 0.5, size.height * 0.85),
                  package: Reccommendscenic(
                    image: AssetImage(
                      "assets/temporary/lorem-ipsum-small-background.png",
                    ),
                    name: "Lorem ipsum",
                    establishedTime: DateTime(2022, 20, 19),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
