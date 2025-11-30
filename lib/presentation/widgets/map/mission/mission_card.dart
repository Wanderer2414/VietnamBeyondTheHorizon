import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vietnambeyondthehorizon/data/models/game_progress.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:vietnambeyondthehorizon/data/models/mission_model.dart';
import 'package:vietnambeyondthehorizon/presentation/constants/color_palette.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/map_controller.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/network_proxy.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/loading_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/image_upload.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/mission/challenge_box.dart';

class MissionCard extends StatefulWidget {
  final MyMapController controller;
  final LocationModel location;
  final Function() onNavigate, onClose;

  MissionCard({
    super.key,
    required this.location,
    required this.controller,
    required this.onNavigate,
    required this.onClose,
  });

  @override
  State<MissionCard> createState() => _MissionCardState();
}

class _MissionCardState extends State<MissionCard> {
  late final MissionModel? _mission;
  XFile? imageFile;
  bool _showRewardEffect = false;
  bool _isReadyToClaim = false;
  @override
  void initState() {
    super.initState();
    retrieveMission().then((value) {
      _mission = value;
      if (_mission != null) {
        SharedPreferences.getInstance().then((value) {
          final src = value.getString(_mission.id);
          if (src != null) {
            imageFile = XFile(src);
            setState(() {});
          }
        });
        setState(() {});
      }
    });

    _checkPendingClaim();
  }

  void _checkPendingClaim() async {
    if (_mission == null) return;

    final prefs = await SharedPreferences.getInstance();

    bool isPending = prefs.getBool('pending_claim_${_mission.id}') ?? false;

    if (isPending && !_mission.isCompleted) {
      setState(() {
        _isReadyToClaim = true;
      });
    }
  }

  Future<MissionModel?> retrieveMission() async {
    final missions = await NetworkProxy.missions;
    //final progressManager = GameProgressManager();

    if (widget.location.currentMissionID != null) {
      try {
        return missions.firstWhere(
          (m) => m.id == widget.location.currentMissionID,
        );
      } catch (e) {
        print("Không tìm thấy mission id: ${widget.location.currentMissionID}");
      }
    }

    for (var mission in missions) {
      for (var correspondingMission in widget.location.missionID) {
        if (mission.id == correspondingMission) {
          // if (progressManager.isMissionCompleted(mission.id)) {
          //   mission.isCompleted = true;
          // }
          return mission;
        }
      }
    }
    return null;
  }

  Future<bool> _claimed() async {
    return true;
  }

  Future<bool> _submitImage(XFile? imagePath) async {
    if (imagePath == null) throw Exception(("Please upload your image"));

    final fileName = imagePath.path.split('/').last;

    FormData formData = FormData.fromMap({
      "files": await MultipartFile.fromFile(
        imagePath.path,
        filename: fileName,
        contentType: DioMediaType("image", "jpeg"),
      ),
      'missionID': int.parse(widget.controller.currentMissionLocation.id),
    });

    print("${_mission?.type}");
    print("ILLUSTRATRION URL: ${_mission?.illustrationURL}");
    print("Mission ID: ${_mission?.id}");
    final responseData = await NetworkProxy.postImage(
      data: formData,
      type: _mission!.type,
    );
    if (responseData != null) {
      print("Call server successfully! Data: $responseData");
      bool isPass = false;

      if (_mission.type == "AI Photo") {
        final result = responseData['result'];

        if (result == "pass") {
          isPass = true;
        } else {
          isPass = false;
        }
      } else if (_mission.type == "Photo") {
        isPass = true;
      }

      if (isPass) {
        String? url;

        if (_mission.type == "Photo") {
          url = responseData['data'];
        } else if (_mission.type == "AI Photo") {
          //url = responseData['url']
        }

        if (url != null) {
          await GameProgressManager().saveMissionPhoto(_mission.id, url);
          print("SAVED uploaded url: $url");
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('pending_claim_${_mission.id}', true);

        return true;
      }
      return false;
    } else {
      print("Response is NULL");
      //TEST------
      return true;
    }
    if (mounted) {
      print("Failed to upload image");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to upload image: ${responseData?['message']} "),
        ),
      );
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double cardHeight = screenSize.height * 0.7;
    if (_mission == null) {
      return SizedBox.shrink();
    }
    return Container(
      height: cardHeight,
      child: Stack(
        children: [
          Container(
            // padding: EdgeInsets.all(20),
            height: cardHeight,
            decoration: BoxDecoration(
              // color: Colors.white.withAlpha(200),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 25, 20, 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      _mission.name,
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Gantari',
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  IconButton(
                                    onPressed: () {
                                      widget.controller.toggleLocationInfo(
                                        context,
                                        widget.location,
                                        widget.onNavigate,
                                        () {},
                                        isReplace: true,
                                      );
                                    },
                                    icon: Icon(
                                      Icons.info_outline_rounded,
                                      size: 32,
                                      color: ColorPalette.accentColor,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),

                              _buildMainTitle("Mission Details"),

                              ChallengeBoxWidget(mission: _mission),
                              SizedBox(height: 25),

                              Row(
                                children: [
                                  _buildMainTitle("Your Submission"),
                                  SizedBox(width: 8),
                                  _mission.isCompleted
                                      ? Icon(
                                          Icons.check_circle_outline,
                                          size: 25,
                                          color: Colors.green,
                                        )
                                      : SizedBox(),
                                ],
                              ),
                              SizedBox(height: 10),
                              Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ImageUploadWidget(
                                    selectedImage: imageFile,
                                    onPicked: (file) {
                                      imageFile = file;
                                      SharedPreferences.getInstance().then(
                                        (value) => value.setString(
                                          _mission.id,
                                          file.path,
                                        ),
                                      );
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),

                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: _ControlPanel(
                          onClaim: () {
                            _claimed().then((value) async {
                              if (value) {
                                int reward = _mission.difficulty;
                                //ADD STARS!!!!!!!!!!!!!!!
                                await GameProgressManager().markAsCompleted(
                                  _mission.id,
                                );
                                await GameProgressManager().addStars(reward);
                                setState(() {
                                  _mission.isCompleted = true;
                                  _isReadyToClaim = false;
                                  _showRewardEffect = true;
                                });

                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.remove(
                                  'pending_claim_${_mission.id}',
                                );

                                // await widget.controller.(_mission!);
                                await Future.delayed(
                                  Duration(milliseconds: 1500),
                                );

                                if (mounted) {
                                  widget.controller.nextMission(context);
                                  Navigator.of(context).pop();
                                  widget.onClose();
                                }
                              }
                            });
                          },
                          onSubmit: () async {
                            try {
                              return await _submitImage(imageFile);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                            return false;
                          },
                          isSubmited: _mission.isCompleted,
                          isReadyToClaim: _isReadyToClaim,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          if (_showRewardEffect) RewardPopup(score: _mission.difficulty),
        ],
      ),
    );
  }

  Widget _buildMainTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black54,
        fontFamily: 'Gantari',
      ),
    );
  }
}

class _ControlPanel extends StatefulWidget {
  final Future<bool> Function() onSubmit;
  final void Function() onClaim;
  final bool isSubmited;
  final bool isReadyToClaim;
  _ControlPanel({
    required this.onSubmit,
    required this.onClaim,
    this.isSubmited = false,
    this.isReadyToClaim = false,
  });

  @override
  State<_ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<_ControlPanel> {
  late Widget _controlButton;
  @override
  void initState() {
    super.initState();
    if (widget.isSubmited)
      _controlButton = _SubmitedButton();
    else if (widget.isReadyToClaim) {
      _controlButton = _ClaimButton(onPressed: widget.onClaim);
    } else
      _controlButton = _SubmitButton(
        onPressed: () {
          widget.onSubmit().then((value) async {
            if (value) {
              showSuccessDialog(context);

              await Future.delayed(Duration(milliseconds: 1500));

              Navigator.of(context).pop();

              if (mounted) {
                setState(() {
                  _controlButton = _ClaimButton(onPressed: widget.onClaim);
                });
              }
            } else {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(content: Text("Failed! Try another photo...")),
              // );
              showFailDialog(context);
              await Future.delayed(Duration(milliseconds: 1500));

              Navigator.of(context).pop();
            }
          });
        },
      );
  }

  @override
  Widget build(BuildContext context) {
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
        _controlButton,
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
        backgroundColor: Colors.amberAccent,
        foregroundColor: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      child: Text("Submit"),
    );
  }
}

class _SubmitedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey,
        foregroundColor: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {},
      child: Text("Submited"),
    );
  }
}

//---------------UI HELPER---------------
Future<dynamic> showSuccessDialog(BuildContext context) async {
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: "Success",
    transitionDuration: Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 80),
                      SizedBox(height: 10),
                      Text(
                        "Correct!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  );
}

Future<dynamic> showFailDialog(BuildContext context) async {
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: "Fail",
    transitionDuration: Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.close_rounded,
                        color: Colors.red.shade600,
                        size: 80,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Incorrect!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  );
}

class RewardPopup extends StatelessWidget {
  final int score;
  const RewardPopup({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 800),
        curve: Curves.elasticOut, // Hiệu ứng nảy bưng bưng
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star_rounded,
                    size: 80,
                    color: Colors.amber,
                  ), // Ngôi sao vàng
                  SizedBox(height: 10),
                  Text(
                    "+$score Stars",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.amber[800],
                      fontFamily: 'Gantari',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
