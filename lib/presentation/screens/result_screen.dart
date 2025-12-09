import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/data/models/game_progress.dart';
import 'package:vietnambeyondthehorizon/data/user/user_account.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/proxy/proxy.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/video_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/result/result_mission.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/result/result_point.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/result/result_summary.dart';
import 'package:vietnambeyondthehorizon/routes/main_route.dart';

class ResultAutoScreen extends StatefulWidget {
  final GameRoute route;
  final UserAccount account;
  const ResultAutoScreen({required this.route, required this.account});
  @override
  _ResultAutoScreenState createState() => _ResultAutoScreenState(
    numberOfMission: route.numberOfMission,
    point: route.collectedStars,
  );
}

class _ResultAutoScreenState extends State<ResultAutoScreen> {
  int currentIndex = 0;
  bool _isToggled = false;

  final List<Widget> _pages;

  _ResultAutoScreenState({required int point, required int numberOfMission})
    : _pages = [
        ResultPagePoint(points: point),
        ResultMission(missions: numberOfMission),
        ResultSummary(
          missions: numberOfMission,
          points: point,
          long: 20,
          submited: numberOfMission,
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
    final uploadData = await widget.account.RepresentPhoto;
    return await NetworkProxy.createVideo(uploadData.urls, uploadData.ids);
  }

  void _onBackHome() async {
    MainRoute.goHome(widget.account);
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
