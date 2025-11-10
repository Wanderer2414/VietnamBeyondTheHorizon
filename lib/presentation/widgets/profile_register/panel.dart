import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/profile_register/age_input.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/profile_register/city_input.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/profile_register/finish_button.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/profile_register/name_box.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/register/email_panel.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/register/extra_login.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/register/sign_button.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/register/password_panel.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/register/re_password_panel.dart';

class Panel extends StatelessWidget {
  final Size size;
  const Panel({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      alignment: Alignment.bottomCenter,
      child: Container(
        width: size.width,
        height: size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: size.width * 0.9,
              height: size.height * 0.19,
              padding: EdgeInsets.only(
                top: size.height * 0.05,
                bottom: size.height * 0.03,
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 2),
                ),
                child: null,
              ),
            ),
            NameBox(size: Size(size.width, size.height * 0.06)),
            SizedBox(height: size.height * 0.03),
            AgeInput(size: Size(size.width, size.height * 0.06)),
            SizedBox(height: size.height * 0.03),
            CityInput(size: Size(size.width, size.height * 0.06)),
            SizedBox(height: size.height * 0.1),
            FinishButton(size: Size(size.width * 0.66, size.height * 0.05)),
          ],
        ),
      ),
    );
  }
}

class _LogInLabel extends StatelessWidget {
  final Size size;
  const _LogInLabel({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      width: size.width,
      padding: EdgeInsets.only(left: size.width * 0.1, top: size.height * 0.3),
      alignment: Alignment.topLeft,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          "Sign up",
          style: TextStyle(
            fontFamily: "InriaSans",
            fontSize: 50,
            fontWeight: FontWeight.w500,
            color: Color(0xFF795100),
          ),
        ),
      ),
    );
  }
}
