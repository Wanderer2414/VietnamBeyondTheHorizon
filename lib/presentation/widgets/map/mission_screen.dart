import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/data/models/mission_model.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/map_controller.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/loading_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/mission/mission_card.dart';
import 'package:vietnambeyondthehorizon/routes/main_route.dart';

class MissionScreen extends StatelessWidget {
  final MyMapController controller;
  final Function() onNavigate, onSubmitedAndClose;
  final MissionModel mission;
  const MissionScreen({
    super.key,
    required this.controller,
    required this.onNavigate,
    required this.onSubmitedAndClose,
    required this.mission,
  });

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LoadingWrapper(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                MainRoute.pop();
              },
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: screenSize.width * 0.9,
                child: MissionCard(
                  mission: mission,
                  controller: controller,
                  onNavigate: onNavigate,
                  onSubmitedAndClose: onSubmitedAndClose,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
