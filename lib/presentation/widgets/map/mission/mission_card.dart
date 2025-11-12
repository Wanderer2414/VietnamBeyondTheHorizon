import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:vietnambeyondthehorizon/animations/screen/transitionRL.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:vietnambeyondthehorizon/data/models/mission_model.dart';
import 'package:vietnambeyondthehorizon/presentation/constants/color_palette.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/map_controller.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/image_upload.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/information_location.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/mission/challenge_box.dart';

class MissionCard extends StatelessWidget {
  final MyMapController controller;
  final LocationModel location;
  final Function(LatLng) onNavigate;

  const MissionCard({
    super.key,
    required this.location,
    required this.controller,
    required this.onNavigate,
  });

  MissionModel? retrieveMission() {
    for (var mission in controller.missionList) {
      if (mission.id == location.missionID) {
        return mission;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final mission = retrieveMission();
    final double cardHeight = screenSize.height * 0.65;
    if (mission == null) {
      return SizedBox(height: 20);
    }
    return Container(
      padding: EdgeInsets.all(20),
      height: cardHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        location.name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        //controller.toggleMissionCard(null);
                        // controller.toggleLocationInfoPanel(location);
                        Navigator.of(context).push(
                          TransitionBTPageRoute(
                            nextScreen: InformationLocation(
                              onClose: () => Navigator.of(context).pop(),
                              onNavigate: (loc) {
                                Navigator.of(context).pop();
                                onNavigate(loc);
                              },
                              locationModel: location,
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.info,
                        size: 35,
                        color: ColorPalette.accentColor,
                      ),
                    ),
                  ],
                ),
                //SizedBox(height: 8),
                Divider(
                  color: ColorPalette.dividerColor,
                  thickness: 1,
                  indent: screenSize.width * 0.1,
                  endIndent: screenSize.width * 0.1,
                ),
                Text(
                  "Mission",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                ),
                ChallengeBoxWidget(mission: mission),
                SizedBox(height: 8),
                Divider(
                  color: ColorPalette.dividerColor,
                  thickness: 1,
                  indent: screenSize.width * 0.1,
                  endIndent: screenSize.width * 0.1,
                ),
                Text(
                  "Your submission",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                ),

                ImageUploadWidget(controller: controller, mission: mission),
              ],
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black87,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    //onSkip
                  },
                  child: Text("Skip"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    //Reward
                  },
                  child: Text("Claim Reward"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
