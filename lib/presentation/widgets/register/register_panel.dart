import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/register/email_panel.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/register/extra_login.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/register/sign_button.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/register/password_panel.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/register/re_password_panel.dart';

class RegisterPanel extends StatelessWidget {
  final Size size;
  const RegisterPanel({super.key, required this.size});

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
          children: [
            _LogInLabel(size: Size(size.width, size.height * 0.11)),
            EmailBox(size: Size(size.width, size.height * 0.1)),
            SizedBox(height: size.height * 0.01),
            PasswordBox(size: Size(size.width, size.height * 0.1)),
            SizedBox(height: size.height * 0.01),
            RePasswordBox(size: Size(size.width, size.height * 0.1)),
            SizedBox(height: size.height * 0.02),
            LoginButton(size: Size(size.width * 0.5, size.height * 0.05)),
            SizedBox(height: size.height * 0.02),
            ExtraLogin(size: Size(size.width, size.height * 0.15)),
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
