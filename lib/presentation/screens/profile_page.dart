import 'package:vietnambeyondthehorizon/data/user/user_account.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/common/side_box.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/home_down_bar.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/profile/avatar_panel.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/profile/decoration.dart'
    as profile;
import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/home_app_bar.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/profile/start_panel.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/profile/tab_content_panel.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/profile/tab_panel.dart';

class ProfilePage extends StatefulWidget {
  final UserAccount user;
  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final SideBox _box = SideBox();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: _key,
      appBar: HomeAppbar(
        superKey: _key,
        size: Size(size.width, size.height * 0.06),
      ),
      backgroundColor: Colors.white,
      drawer: Drawer(child: _box),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            CustomPaint(
              painter: profile.Decoration(),
              size: Size(size.width, size.height),
            ),
            _Content(user: widget.user),
          ],
        ),
      ),

      floatingActionButton: HomeDownBar(
        size: Size(size.width * 0.9, size.height * 0.13),
        account: widget.user,
      ),
    );
  }
}

class _Content extends StatefulWidget {
  final UserAccount user;
  const _Content({required this.user});

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with gradient + avatar stacked on top
        SizedBox(height: 20),
        AvatarPanel(),
        SizedBox(height: 20),

        // Name & Location
        Text(
          widget.user.username,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            fontFamily: 'Courier',
            color: Colors.black87,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          widget.user.city,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade600,
            fontFamily: 'Courier',
          ),
        ),
        const SizedBox(height: 18),

        // Stats Section
        StatPanel(
          missions_completed: widget.user.NumberOfMissions,
          numberOfPhotos: widget.user.NumberOfPhotos,
        ),

        // Tab Bar
        TabPanel(
          selectedIndex: _selectedIndex,
          onTap: (index) => setState(() {
            _selectedIndex = index;
          }),
        ),

        // Content area
        TabContentPanel(selectedIndex: _selectedIndex, account: widget.user),
      ],
    );
  }
}
