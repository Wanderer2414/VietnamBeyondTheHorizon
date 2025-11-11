import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/map_controller.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/map_show.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/search_bar.dart';

class Content extends StatelessWidget {
  Content({required this.controller, required this.screenSize});

  final MyMapController controller;
  final Size screenSize;
  final StateProvider<bool> _provider = StateProvider<bool>((ref) => false);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Stack(
        children: [
          MapShow(controller: controller, provider: _provider),
          SearchBarWidget(controller: controller, provider: _provider),

          //MISSION CARD

          //LOCATION INFORMATION
          // AnimatedPositioned(
          //   duration: const Duration(milliseconds: 600),
          //   curve: Curves.fastEaseInToSlowEaseOut,
          //   top: controller.isLocationInfoPanelVisible
          //       ? screenSize.height * 0.5
          //       : screenSize.height,
          //   left: 0,
          //   right: 0,
          //   child: SizedBox(
          //     height: screenSize.height * 0.5,
          //     child: SingleChildScrollView(
          //       child: controller.selectedLocation == null
          //           ? const SizedBox()
          //           : LocationInfoWidget(
          //               location: controller.selectedLocation!,
          //               onClose: () => controller.toggleLocationInfoPanel(null),
          //               controller: controller,
          //             ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
