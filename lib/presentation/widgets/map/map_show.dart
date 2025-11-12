import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/map_controller.dart';

class MapShow extends StatefulWidget {
  const MapShow({required this.controller});

  final MyMapController controller;

  @override
  State<MapShow> createState() => _MapShowState();
}

class _MapShowState extends State<MapShow> {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: widget.controller.mapController,
      options: widget.controller.mapOptions(
        onMapReady: () {
          widget.controller.onMapReady();
          setState(() {});
        },
        context: context,
      ),
      children: widget.controller.mapLayers(context, () => setState(() {})),
    );
  }
}
