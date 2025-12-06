import 'package:vietnambeyondthehorizon/data/user/user_account.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/loading_screen.dart';
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
                image: DecorationImage(
                  image: AssetImage("assets/backgrounds/blur_map.png"),
                  alignment: Alignment.topCenter,
                ),
              ),
            ),

            Column(
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
          ],
        ),
        floatingActionButton: HomeDownBar(
          size: Size(screenSize.width * 0.9, screenSize.height * 0.13),
          account: widget.user,
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
