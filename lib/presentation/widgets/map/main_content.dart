import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/map_controller.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/map_show.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/search_bar.dart';

class Content extends StatefulWidget {
  Content({required this.controller, required this.screenSize, this.onTap});

  final MyMapController controller;
  final Size screenSize;
  final Function()? onTap;

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  Stack? _content;

  final StateProvider<bool> _provider = StateProvider<bool>((ref) => false);
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Size screenSize = MediaQuery.of(context).size;
    _content = Stack(
      children: [
        MapShow(controller: widget.controller, provider: _provider),
        SearchBarWidget(
          controller: widget.controller,
          provider: _provider,
          size: Size(screenSize.width * 0.9, screenSize.height * 0.05),
          onTap: widget.onTap,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _content!;
  }
}
