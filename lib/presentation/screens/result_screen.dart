import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/data/models/game_progress.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/network_proxy.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/video_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/result/result_mission.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/result/result_point.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/result/result_summary.dart';

class ResultAutoScreen extends StatefulWidget {
  @override
  _ResultAutoScreenState createState() => _ResultAutoScreenState();
}

class _ResultAutoScreenState extends State<ResultAutoScreen> {
  int currentIndex = 0;
  bool _isToggled = false;
  int point = GameProgressManager().collectedStars;

  final List<Widget> _pages = [
    ResultPagePoint(points: GameProgressManager().collectedStars),
    ResultMission(missions: GameProgressManager().numberMissionCompleted),
    ResultSummary(
      missions: GameProgressManager().numberMissionCompleted,
      points: GameProgressManager().collectedStars,
      long: 20,
      submited: GameProgressManager().numberImageSubmited,
    ),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      autoPlay();
    });
  }

  void autoPlay() {
    Future.delayed(const Duration(seconds: 2), step);
  }

  void step() {
    if (currentIndex >= _pages.length - 1) {
      Future.delayed(const Duration(milliseconds: 700), toggleButton);
    }
    if (currentIndex < _pages.length - 1) {
      setState(() {
        currentIndex++;
      });

      Future.delayed(const Duration(seconds: 3), step);
    }
  }

  void toggleButton() {
    setState(() {
      _isToggled = true;
    });
  }

  Future<String?> generateRecapVideo() async {
    List<List<String>> uploadedData = GameProgressManager().getOrderedPhotos();

    if (uploadedData[0].isEmpty) {
      print("No images exist");
      return null;
    }

    List<String> urls = uploadedData[0];
    List<String> locationIds = uploadedData[1];
    final Map<String, dynamic> body = {
      "urls": urls,
      "frame_index_list": locationIds,
      "group_num_list": List.filled(urls.length, "1"),
    };

    print(" Sending Body: $body");

    try {
      final responseData = await NetworkProxy.createVideo(body: body);

      if (responseData != null) {
        print("---Create video success: $responseData");

        final videoUrl = responseData['data'];
        print("Video URL: ${videoUrl}");
        if (videoUrl != null && videoUrl.toString().isNotEmpty) {
          return videoUrl.toString();
        }
      }
    } catch (e) {
      print("Error API Video: $e");
    }

    return null;
  }

  void _onBackHome() async {
    await GameProgressManager().resetProgress();

    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 800),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                ),
                child: child,
              ),
            );
          },
          child: Container(
            key: ValueKey<int>(currentIndex),
            child: _pages[currentIndex],
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: !_isToggled
          ? null
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  FloatingActionButton.extended(
                    heroTag: "btn_home",
                    onPressed: _onBackHome,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    elevation: 4,
                    icon: const Icon(Icons.home_rounded),
                    label: const Text(
                      "Home",
                      style: TextStyle(
                        fontFamily: "Gantari",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),
                  FloatingActionButton.extended(
                    heroTag: "btn_video",
                    onPressed: () async {
                      //Review the journey(VIDEO)

                      final videoUrls = await generateRecapVideo();
                      if (videoUrls != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => VideoApp(path: videoUrls),
                          ),
                        );
                      }
                    },
                    backgroundColor: const Color.fromARGB(255, 124, 60, 0),
                    icon: const Icon(
                      Icons.video_collection_outlined,
                      color: Color.fromARGB(255, 255, 255, 255),
                      size: 20,
                    ),
                    label: const Text(
                      "Relive your journey",
                      style: TextStyle(
                        fontFamily: "Gantari",
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
