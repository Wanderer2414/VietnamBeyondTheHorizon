import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/map_controller.dart';

class MapShow extends ConsumerWidget {
  final StateProvider<bool> provider;
  const MapShow({required this.controller, required this.provider});

  final MyMapController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(provider);
    return FlutterMap(
      mapController: controller.mapController,
      options: controller.mapOptions(
        onMapReady: controller.onMapReady,
        context: context,
      ),
      children: controller.mapLayers(context),
    );
  }
}
