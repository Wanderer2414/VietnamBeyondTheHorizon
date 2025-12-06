import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/data/user/user_account.dart';
import 'package:vietnambeyondthehorizon/routes/main_route.dart';

class HomeButton extends StatelessWidget {
  final UserAccount account;
  final double radius;
  const HomeButton({super.key, required this.radius, required this.account});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => MainRoute.goHome(account),
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.zero,
        minimumSize: Size.square(radius / 2),
        maximumSize: Size.square(radius),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      child: Container(
        padding: EdgeInsets.zero,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/icons/home.png"),
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
    );
  }
}
