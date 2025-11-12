import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/map_controller.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/mission/mission_card.dart';

class MissionScreen extends StatelessWidget {
  final MyMapController controller;
  const MissionScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: screenSize.width * 0.9,
              child: MissionCard(
                location: controller.selectedLocation!,
                controller: controller,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
