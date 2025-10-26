import 'package:vietnambeyondthehorizon/presentation/widgets/home/decoration.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/daily_box.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/gems_box.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/home_app_bar.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/home_down_bar.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/side_box.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/stars_box.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/visited_places_box.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/greeting_box.dart';
import 'package:flutter/material.dart';

class HomeStation extends StatelessWidget {
  const HomeStation({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: HomeAppbar(
        superKey: _scaffoldKey,
        size: Size(screenSize.width, screenSize.height * 0.06),
      ),
      drawer: Drawer(
        child: SideBox(size: Size(screenSize.width * 0.4, screenSize.height)),
      ),
      body: Stack(
        children: [
          CustomPaint(
            size: Size(screenSize.width, screenSize.height),
            painter: HomeDecoration(),
          ),

          Column(
            children: [
              SizedBox(height: screenSize.height * 0.03),
              //Hi box
              GreetingBox(
                size: Size(screenSize.width * 0.9, screenSize.height * 0.15),
                userName: "Quoc Huy",
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
                      fontFamily: "Jost",
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                ],
              ),

              //Scroll view of visited place
              VisitedPlaceBox(
                size: Size(screenSize.width * 0.9, screenSize.height * 0.4),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: HomeDownBar(
        size: Size(screenSize.width * 0.9, screenSize.height * 0.13),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
