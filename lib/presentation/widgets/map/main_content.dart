import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/map_controller.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/map_show.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/search_bar.dart';

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
    return Stack(
      children: [
        MapShow(controller: widget.controller, size: screenSize),
        SearchBarWidget(
          controller: widget.controller,
          size: Size(screenSize.width * 0.9, screenSize.height * 0.05),
          onTap: () => setState(() {}),
        ),
      ],
    );
  }
}
