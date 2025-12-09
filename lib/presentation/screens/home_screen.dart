import 'dart:async';

import 'package:vietnambeyondthehorizon/data/user/user_account.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/loading_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/profile_page.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/common/side_box.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/daily_box.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/home_app_bar.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/home_down_bar.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/visited_places_box.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/greeting_box.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final UserAccount user;
  const HomeScreen({super.key, required this.user});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final sideBox = SideBox();
  double index = 0;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return LoadingWrapper(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: HomeAppbar(
          superKey: _scaffoldKey,
          size: Size(screenSize.width, screenSize.height * 0.06),
        ),
        drawer: Drawer(child: sideBox),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage("assets/backgrounds/blur_map.png"),
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            MainContent(screenSize: screenSize, widget: widget, index: index),
          ],
        ),
        floatingActionButton: HomeDownBar(
          size: Size(screenSize.width * 0.9, screenSize.height * 0.13),
          account: widget.user,
          onGoHome: () => setState(() => index = 0),
          onGoProfile: () => setState(() => index = 1),
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}

class MainContent extends StatefulWidget {
  const MainContent({
    super.key,
    required this.screenSize,
    required this.widget,
    required this.index,
  });

  final Size screenSize;
  final HomeScreen widget;
  final double index;

  @override
  State<MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  Timer? _timer;
  double _old = 0, _current = 0, _percent = 0, _offset = 0, _duration = 0;

  @override
  void didChangeDependencies() {
    _timer?.cancel();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if ((_current - widget.index).abs() > 0.01) {
      _timer?.cancel();
      _old = _current;
      _current = widget.index;
      _percent = 0;
      _offset = _old;
      _duration = _current - _old;
      _timer = Timer.periodic(const Duration(microseconds: 10), (timer) {
        _percent += 0.005;
        if (_percent >= 1) {
          _percent = 1;
          _timer?.cancel();
        }
        _offset = _old + _percent * _duration;
        setState(() {});
      });
    }
    return OverflowBox(
      maxWidth: widget.screenSize.width * 3,
      child: Padding(
        padding: EdgeInsetsGeometry.only(
          left: (1 - _offset) * widget.screenSize.width,
        ),
        child: Row(
          children: [
            HomeContent(screenSize: widget.screenSize, widget: widget.widget),
            ProfilePage(user: widget.widget.user),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
    required this.screenSize,
    required this.widget,
  });

  final Size screenSize;
  final HomeScreen widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenSize.width,
      height: screenSize.height,
      child: Column(
        children: [
          SizedBox(height: screenSize.height * 0.03),
          //Hi box
          GreetingBox(
            size: Size(screenSize.width * 0.9, screenSize.height * 0.1),
            userName: widget.user.username,
          ),
          SizedBox(height: screenSize.height * 0.03),

          //Daily box
          DailyBox(
            size: Size(screenSize.width * 0.9, screenSize.height * 0.19),
          ),

          SizedBox(height: screenSize.height * 0.02),

          //Visited label
          Row(
            children: [
              SizedBox(width: screenSize.width * 0.06),
              Text(
                "VISITED PLACES",
                style: TextStyle(
                  fontFamily: "Kay Pho Du",
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
            ],
          ),

          //Scroll view of visited place
          VisitedPlaceBox(
            size: Size(screenSize.width * 0.9, screenSize.height * 0.36),
            listOfVideo: widget.user.videos,
          ),
        ],
      ),
    );
  }
}
