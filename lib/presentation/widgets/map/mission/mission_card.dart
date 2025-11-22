import 'dart:convert';
import 'dart:io';

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
import 'package:http/http.dart' as http;
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
      for (var correspondingMission in location.missionID) {
        if (mission.id == correspondingMission) {
          return mission;
        }
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

          Align(
            alignment: Alignment.bottomCenter,
            child: _ControlPanel(),
          ),
        ],
      ),
    );
  }
}

class _ControlPanel extends StatefulWidget {
  @override
  State<_ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<_ControlPanel> {
  bool _isSubmited = false;

  Future<void> _submitImage(String imagePath) async {

    try {
      var uri = Uri.parse('http://<YOUR_SERVER_IP>:5000/check_image');
      var request = http.MultipartRequest('POST', uri);
      request.files.add(
        await http.MultipartFile.fromPath('image', imagePath),
      );

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

    } catch(e) {};
  }

  @override
  Widget build(BuildContext context) {
    Widget container;
    if (_isSubmited) {
      container = _ClaimButton(onPressed: () => setState(() => _isSubmited = true));
    }
    else {
      container = _SubmitButton(onPressed: () => setState(() {
          _isSubmited = true; 
          // _submitImage()
      }));
    }

    return Row(
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
        container
      ],
    );
  }
}

class _ClaimButton extends StatelessWidget {
  final void Function() onPressed;
  const _ClaimButton({required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onPressed,
      child: Text("Claim Reward"),
    );
  }
}


class _SubmitButton extends StatelessWidget {
  final void Function() onPressed;
  const _SubmitButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onPressed,
      child: Text("Submit"),
    );
  }
}
