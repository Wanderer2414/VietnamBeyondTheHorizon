import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/data/packages/reccommend_scenic.dart';

import 'package:vietnambeyondthehorizon/presentation/widgets/home/scenic_panel.dart'
    as home_widgets;

class VisitedPlaceBox extends StatefulWidget {
  final Size size;
  final double miniWidth;
  VisitedPlaceBox({super.key, required this.size})
    : miniWidth = size.width * 0.55;

  @override
  State<VisitedPlaceBox> createState() => _VisitedPlaceBoxState();
}

class _VisitedPlaceBoxState extends State<VisitedPlaceBox> {
  double targetIndex = 0;
  @override
  Widget build(BuildContext context) {
    ScrollController scrollbar = ScrollController();
    return Container(
      width: widget.size.width,
      height: widget.size.height,
      alignment: Alignment.topCenter,
      child: Scrollbar(
        controller: scrollbar,
        child: SingleChildScrollView(
          controller: scrollbar,
          scrollDirection: Axis.horizontal,
          child: Container(
            height: widget.size.height,
            padding: EdgeInsets.only(bottom: widget.size.height * 0.05),
            child: Row(
              spacing: 20,
              children: List.generate(10, (index) {
                double scale = 1 - (index - targetIndex).abs() / 5;
                if (scale < 0) scale = 0;
                return home_widgets.ScenicPanel(
                  size: Size(widget.miniWidth, widget.size.height * 0.9),
                  scale: scale,
                  package: Reccommendscenic(
                    image: const AssetImage(
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
        notificationPredicate: (notification) {
          setState(() {
            targetIndex =
                (notification.metrics.pixels + 15) / (widget.miniWidth + 20);
            targetIndex += (widget.size.width) / (widget.miniWidth + 20) / 4;
          });
          return (notification.depth == 0);
        },
      ),
    );
  }
}
