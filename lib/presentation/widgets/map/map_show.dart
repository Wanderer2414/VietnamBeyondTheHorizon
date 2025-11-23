import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/map_controller.dart';

class MapShow extends StatefulWidget {
  final Size size;
  const MapShow({super.key, required this.controller, required this.size});

  final MyMapController controller;

  @override
  State<MapShow> createState() => _MapShowState();
}

class _MapShowState extends State<MapShow> {
  @override
  void initState() {
    super.initState();
    widget.controller.resetMap = () {
      setState(() {
        
      });
    };
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width,
      height: widget.size.height,
      child: FlutterMap(
        mapController: widget.controller.mapController,
        options: widget.controller.mapOptions(
          onMapReady: () {
            setState(() {});
          },
          context: context,
        ),
        children: widget.controller.mapLayers(context),
      ),
    );
  }
}
