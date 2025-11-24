import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/extra/text_measure.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/map_controller.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/map_show.dart';

class Content extends StatefulWidget {
  Content({required this.controller, required this.screenSize});

  final MyMapController controller;
  final Size screenSize;

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    widget.controller.resetMap = () {
      widget.controller.fetchRoute(
        widget.controller.currentLocation,
        widget.controller.currentMissionLocation.coordinates,
      );
      setState(() {});
    };
    return Stack(
      children: [
        MapShow(controller: widget.controller, size: screenSize),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: screenSize.width,
            height: screenSize.height * 0.1,
            alignment: Alignment.centerLeft,
            child: Container(
              width: screenSize.width * 0.75,
              height: screenSize.height * 0.07,
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              alignment: Alignment.center,
              child: ScrollTextButton(
                onPressed: () {
                  final loc = widget.controller.currentMissionLocation;
                  widget.controller.fetchRoute(
                    widget.controller.currentLocation,
                    loc.coordinates,
                  );
                  widget.controller.moveToLocation(loc.coordinates, 15);
                },
                text:
                    "Go to " +
                    widget.controller.currentMissionLocation.name +
                    "...\t",
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ScrollTextButton extends StatefulWidget {
  final Function() onPressed;
  const ScrollTextButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;

  @override
  State<ScrollTextButton> createState() => _ScrollTextButtonState();
}

class _ScrollTextButtonState extends State<ScrollTextButton> {
  final ScrollController _scroll_controller = ScrollController();
  Timer? _autoScroll;
  @override
  void initState() {
    super.initState();
    _autoScroll = Timer.periodic(const Duration(milliseconds: 10), (e) {
      double next =
          (_scroll_controller.offset + 1) %
          _scroll_controller.position.maxScrollExtent;
      if (next >
          TextMeasure(
                widget.text * 2,
                TextStyle(
                  fontFamily: "Kay Pho Du",
                  color: Colors.white,
                  fontSize: 30,
                ),
              ).width /
              2)
        next = 0;
      _scroll_controller.jumpTo(next);
    });
  }

  @override
  void dispose() {
    if (_autoScroll != null) {
      _autoScroll!.cancel();
    }
    _scroll_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressed,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
        ),
      ),
      child: SingleChildScrollView(
        controller: _scroll_controller,
        scrollDirection: Axis.horizontal,
        child: Text(
          widget.text * 2,

          style: TextStyle(
            fontFamily: "Kay Pho Du",
            color: Colors.white,
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
