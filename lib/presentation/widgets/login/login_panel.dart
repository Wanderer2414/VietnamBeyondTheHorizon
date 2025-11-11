import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/common/input_panel_t1.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/login/extra_login.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/login/forget_text.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/login/login_button.dart';

class LoginPanel extends StatelessWidget {
  final Size size;
  final Function()? onTap;
  const LoginPanel({super.key, required this.size, this.onTap});

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
            InputPanelT1(
              size: Size(size.width, size.height * 0.1),
              content: "Email",
              onTap: onTap,
            ),
            SizedBox(height: size.height * 0.01),
            InputPanelT1(
              size: Size(size.width, size.height * 0.1),
              content: "Password",
              onTap: onTap,
            ),
            SizedBox(
              width: size.width * 0.8,
              height: size.height * 0.05,
              child: ForgetBox(size: Size(size.width, size.height * 0.05)),
            ),
            LoginButton(size: Size(size.width * 0.5, size.height * 0.05)),
            SizedBox(height: size.height * 0.02),
            ExtraLogin(size: Size(size.width, size.height * 0.25)),
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
          "Log In",
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
