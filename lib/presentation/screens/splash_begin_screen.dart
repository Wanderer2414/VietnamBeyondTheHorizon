import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vietnambeyondthehorizon/data/user/user_account.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/network_proxy.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/auth_controller.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/dio_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), navigateNext);
  }

  void navigateNext() async {
    try {
      final user = await NetworkProxy.account;
      ref.read(userProvider.notifier).setUser(user);
      Navigator.pushReplacementNamed(context, "home");
    } catch (e) {
      Navigator.pushReplacementNamed(context, "intro");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth,
      height: screenHeight,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF6262), Color(0xFFEA7F38)],
          begin: AlignmentGeometry.xy(-1, -1.5),
          end: AlignmentGeometry.xy(0, 1.5),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: screenHeight * 0.03,
        children: [
          AppIcon(screenWidth: screenWidth),
          AppTitle(size: Size(screenWidth, screenHeight)),
          // Waiting4L(side: screenWidth * 0.15),
        ],
      ),
    );
  }
}

class Waiting4L extends StatefulWidget {
  final double side;
  const Waiting4L({super.key, required this.side});

  @override
  State<Waiting4L> createState() => _Waiting4LState();
}

class _Waiting4LState extends State<Waiting4L> {
  double _angle = 0;
  late final Timer _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 80), handle);
  }

  void handle(Timer time) {
    setState(() {
      _angle -= 0.2;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: _angle,
      child: Icon(Icons.sync, size: widget.side, color: Colors.black54),
    );
  }
}

class AppTitle extends StatelessWidget {
  final Size size;
  const AppTitle({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width * 0.9,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          children: [
            Text(
              "VIETNAM",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              "Beyond The Horizon",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppIcon extends StatelessWidget {
  const AppIcon({super.key, required this.screenWidth});

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.3,
      height: screenWidth * 0.3,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFFF6F61),
        image: DecorationImage(image: AssetImage("assets/icons/app_icon.png")),
      ),
      child: null,
    );
  }
}
