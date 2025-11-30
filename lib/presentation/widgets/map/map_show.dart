import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:vietnambeyondthehorizon/data/models/game_progress.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/map_controller.dart';

class MapShow extends StatefulWidget {
  final Size size;
  const MapShow({super.key, required this.controller, required this.size});

  final MyMapController controller;

  @override
  State<MapShow> createState() => _MapShowState();
}

class _MapShowState extends State<MapShow> {
  MapController _mapController = MapController();
  @override
  void initState() {
    super.initState();
    widget.controller.resetMap = () {
      setState(() {});
    };
  }

  @override
  void dispose() {
    super.dispose();
    GameProgressManager().resetProgress();
  }

  @override
  Widget build(BuildContext context) {
    widget.controller.mapController = _mapController;
    return SizedBox(
      width: widget.size.width,
      height: widget.size.height,
      child: FlutterMap(
        mapController: _mapController,
        options: widget.controller.mapOptions(
          onMapReady: () => setState(() {}),
          context: context,
        ),
        children: widget.controller.mapLayers(
          context,
          widget.controller.userRoute,
          (location) {
            widget.controller.toggleMissionCard(context, location);
          },
          isGameMode: true,
        ),
      ),
    );
  }
}
