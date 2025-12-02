import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/data/packages/reccommend_scenic.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/network_proxy.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/user_history.dart';

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
  List<GlobalKey<home_widgets.ScenicPanelState>> keys = [];
  List<home_widgets.ScenicPanel> list = [];
  double targetIndex = 0;
  List<String> videoUrls = [];
  @override
  void initState() {
    super.initState();

    videoUrls = UserHistoryManager().videoUrls;
    print("Video URL in Visited Box $videoUrls");
    for (int i = 0; i < videoUrls.length; i++) {
      keys.add(GlobalKey<home_widgets.ScenicPanelState>());
      list.add(
        home_widgets.ScenicPanel(
          key: keys[i],
          size: Size(widget.miniWidth, widget.size.height * 0.9),
          package: Reccommendscenic(
            image: const AssetImage(
              "assets/temporary/lorem_ipsum_background.png",
            ),
            name: "",
            establishedTime: DateTime(2022, 20, 19),
            videoUrl: videoUrls[i],
          ),
        ),
      );
    }
  }

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
            child: Row(spacing: 20, children: list),
          ),
        ),
        notificationPredicate: (notification) {
          setState(() {
            targetIndex =
                (notification.metrics.pixels + 15) / (widget.miniWidth + 20);
            targetIndex += (widget.size.width) / (widget.miniWidth + 20) / 4;

            int current = targetIndex.floor() - 1;
            for (int i = 0; i < 4; i++) {
              if (current + i < keys.length && current + i >= 0) {
                keys[current + i].currentState?.setScale(
                  1 - (targetIndex - current - i).abs() / 5,
                );
              }
            }
          });
          return (notification.depth == 0);
        },
      ),
    );
  }
}
