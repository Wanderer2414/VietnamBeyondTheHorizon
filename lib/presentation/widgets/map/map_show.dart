import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:vietnambeyondthehorizon/data/models/game_progress.dart';
import 'package:vietnambeyondthehorizon/data/user/user_account.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/map_controller.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/marker_layer.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/timeline_progress.dart';

class MapShow extends StatefulWidget {
  final Size size;
  final UserAccount account;
  const MapShow({
    super.key,
    required this.controller,
    required this.size,
    required this.account,
  });

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
        children: widget.controller.mapLayers(context, [
          MissionLayer(context, widget.controller, widget.account),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TimelineProgress(
                  currentIndex: GameProgressManager.numberImageSubmited - 1,
                  totalSteps: GameProgressManager.missions.length,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
