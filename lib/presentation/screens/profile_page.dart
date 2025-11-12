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
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final SideBox _box = SideBox();

  // Sample photo data for album view
  final List<String> photos = [
    'assets/images/photo1.jpg',
    'assets/images/photo2.jpg',
    'assets/images/photo3.jpg',
    'assets/images/photo4.jpg',
    'assets/images/photo5.jpg',
    'assets/images/photo6.jpg',
  ];

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
            _Content(photos: photos),
          ],
        ),
      ),

      floatingActionButton: HomeDownBar(
        size: Size(size.width * 0.9, size.height * 0.13),
      ),
    );
  }
}

class _Content extends StatefulWidget {
  const _Content({required this.photos});

  final List<String> photos;

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
        const Text(
          'Nguyen Van A',
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
          'Thanh pho Ho Chi Minh',
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade600,
            fontFamily: 'Courier',
          ),
        ),
        const SizedBox(height: 18),

        // Stats Section
        StatPanel(),

        // Tab Bar
        TabPanel(
          selectedIndex: _selectedIndex,
          onTap: (index) => setState(() {
            _selectedIndex = index;
          }),
        ),

        // Content area
        TabContentPanel(selectedIndex: _selectedIndex, photos: widget.photos),
      ],
    );
  }
}
