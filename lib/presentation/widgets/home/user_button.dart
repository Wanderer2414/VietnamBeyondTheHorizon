import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/data/user/user_account.dart';
import 'package:vietnambeyondthehorizon/routes/main_route.dart';

class UserButton extends StatelessWidget {
  final UserAccount account;
  final double radius;
  const UserButton({super.key, required this.radius, required this.account});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        MainRoute.goProfilePage(account);
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        minimumSize: Size.square(radius / 2),
        maximumSize: Size.square(radius),
        padding: EdgeInsets.zero,
      ),

      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/icons/user.png")),
        ),
      ),
    );
  }
}
