import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:vietnambeyondthehorizon/data/models/mission_model.dart';
import 'package:vietnambeyondthehorizon/presentation/constants/color_palette.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/dio_service.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/map_controller.dart';
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
  @override
  void initState() {
    super.initState();
    _mission = retrieveMission();
    if (_mission != null) {
      SharedPreferences.getInstance().then((value) {
        imageFile = XFile(value.getString(_mission.id)!);

        setState(() {});
      });
    }
  }

  MissionModel? retrieveMission() {
    for (var mission in widget.controller.allMission) {
      for (var correspondingMission in widget.location.missionID) {
        if (mission.id == correspondingMission) {
          return mission;
        }
      }
    }
    return null;
  }

  Future<bool> _claimed() async {
    return true;
  }

  // Future<XFile?> compressImage(XFile file) async {
  //   final filePath = file.path;
  //   final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
  //   final splitted = filePath.substring(0, (lastIndex));
  //   final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

  //   var result = await FlutterImageCompress.compressAndGetFile(
  //     file.path,
  //     outPath,
  //     quality: 70,
  //     minWidth: 800,
  //     minHeight: 800,
  //   );
  //   return result;
  // }

  Future<bool> _submitImage(XFile? imagePath) async {
    if (imagePath == null) throw Exception(("Please upload your image"));
    var uploadUrl = "/mission/similarity";

    final fileName = imagePath.path.split('/').last;

    FormData formData = FormData.fromMap({
      "files": await MultipartFile.fromFile(
        imagePath.path,
        filename: fileName,
        contentType: DioMediaType("image", "jpeg"),
      ),
      'missionID': int.parse(widget.controller.currentMissionLocation.id),
    });

    try {
      final response = await DioService.dio.post(uploadUrl, data: formData);

      print("Upload success: ${response.data}");
      return true;
    } catch (e) {
      if (e is DioException) {
        print("Lỗi server trả về: ${e.response?.data}");
      }
    } finally {}
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                        _buildMainTitle("Your Submission"),
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
                                  (value) =>
                                      value.setString(_mission.id, file.path),
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
                      _claimed().then((value) {
                        if (value) {
                          widget.controller.nextMission(context);
                          Navigator.of(context).pop();
                          widget.onClose();
                        }
                      });
                    },
                    onSubmit: () async {
                      return await _submitImage(imageFile);
                    },
                    isSubmited: _mission.isCompleted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black54, // Màu xám đậm cho tiêu đề phụ
        fontFamily: 'Gantari',
      ),
    );
  }
}

class _ControlPanel extends StatefulWidget {
  final Future<bool> Function() onSubmit;
  final void Function() onClaim;
  final bool isSubmited;
  _ControlPanel({
    required this.onSubmit,
    required this.onClaim,
    this.isSubmited = false,
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
    else
      _controlButton = _SubmitButton(
        onPressed: () {
          widget.onSubmit().then((value) {
            if (value) {
              setState(() {
                _controlButton = _ClaimButton(onPressed: widget.onClaim);
              });
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
        backgroundColor: Colors.amber,
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
