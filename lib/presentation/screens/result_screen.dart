import 'package:flutter/material.dart';
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
  final List<Widget> _pages = [
    const ResultPagePoint(points: 13),
    const ResultMission(missions: 5),
    const ResultSummary(missions: 5, points: 13, long: 20, submited: 5),
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
      floatingActionButton: !_isToggled
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                //Review the journey(VIDEO)
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
    );
  }
}
