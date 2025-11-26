import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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

  Future<XFile?> compressImage(XFile file) async {
    final filePath = file.path;
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

    var result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      outPath,
      quality: 70,
      minWidth: 800,
      minHeight: 800,
    );
    return result;
  }

  Future<bool> _submitImage(XFile? imagePath) async {
    if (imagePath == null) throw Exception(("Please upload your image"));
    var uploadUrl = "/mission/similarity";

    final fileName = imagePath.path.split('/').last;

    final compressedFile = await compressImage(imagePath);
    FormData formData = FormData.fromMap({
      "files": await MultipartFile.fromFile(
        compressedFile!.path,
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
    final double cardHeight = screenSize.height * 0.65;
    if (_mission == null) {
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
                        widget.location.name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

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
                ChallengeBoxWidget(mission: _mission),
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

                ImageUploadWidget(
                  selectedImage: imageFile,
                  onPicked: (file) {
                    imageFile = file;
                    SharedPreferences.getInstance().then(
                      (value) => value.setString(_mission.id, file.path),
                    );
                    setState(() {});
                  },
                ),
                SizedBox(
                  width: screenSize.width,
                  height: screenSize.height * 0.07,
                ),
              ],
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
