import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:vietnambeyondthehorizon/data/models/game_progress.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/mission/image_upload_lock_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/mission/mission_card.dart';

class MissionCardScreen extends StatefulWidget {
  final MissionCard missionCard;
  final LatLng userCurrentGPS;

  const MissionCardScreen({
    Key? key,
    required this.missionCard,
    required this.userCurrentGPS,
  }) : super(key: key);

  @override
  State<MissionCardScreen> createState() => _MissionCardScreenState();
}

class _MissionCardScreenState extends State<MissionCardScreen> {
  bool get _isUnlocked =>
      GameProgressManager.isCurrentStepCheckedIn(widget.missionCard.mission.id);
  bool _isCheckingGPS = false;
  final picker = ImagePicker();
  XFile? imageFile;
  bool _showUnlockBanner = false;
  void _triggerUnlockEffect() async {
    setState(() {
      _showUnlockBanner = true;
    });

    await Future.delayed(Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _showUnlockBanner = false;
      });
    }
  }

  void _handleCheckInUpload() async {
    setState(() => _isCheckingGPS = true);
    await Future.delayed(Duration(seconds: 1));

    if (imageFile != null) {
      if (await GameProgressManager.checkInSuccess(imageFile!.path)) {
        if (mounted) {
          _triggerUnlockEffect();
        }
      }
    } else {}

    if (mounted) {
      setState(() => _isCheckingGPS = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double cardHeight = screenSize.height * 0.7;
    return Stack(
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: _isUnlocked ? 0 : 5,
            sigmaY: _isUnlocked ? 0 : 5,
          ),
          child: widget.missionCard,
        ),

        if (!_isUnlocked)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.black.withOpacity(0.4),
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Icon(
                          Icons.lock_outline_rounded,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: 15),

                      Text(
                        "MISSION LOCKED",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 8),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          "Proof of presence required to access this mission data.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            height: 1.8,
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.gps_fixed,
                                  size: 16,
                                  color: Colors.orangeAccent,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "GPS VERIFICATION",
                                  style: TextStyle(
                                    color: Colors.orangeAccent,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            LockedImageUploadWidget(
                              isChecking: _isCheckingGPS,
                              selectedImage: imageFile,
                              onPicked: (file) {
                                setState(() => imageFile = file);
                                _handleCheckInUpload();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        Padding(
          padding: EdgeInsetsGeometry.only(top: (cardHeight / 2 - 100)),
          child: AnimatedScale(
            scale: _showUnlockBanner ? 1.0 : 0.0,
            duration: Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF2994A), Color(0xFFF2C94C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_open_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  SizedBox(height: 15),

                  Text(
                    "MISSION UNLOCKED!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Let's explore this place!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
