import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/common/input_panel_t1.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/login/extra_login.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/login/forget_text.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/login/login_button.dart';

class LoginPanel extends StatefulWidget {
  final Size size;
  final Function()? onTap;
  const LoginPanel({super.key, required this.size, this.onTap});

  @override
  State<LoginPanel> createState() => _LoginPanelState();
}

class _LoginPanelState extends State<LoginPanel> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size.height,
      alignment: Alignment.bottomCenter,
      child: Container(
        width: widget.size.width,
        height: widget.size.height * 0.7,
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
            _LogInLabel(
              size: Size(widget.size.width, widget.size.height * 0.11),
            ),
            InputPanelT1(
              controller: emailCtrl,
              size: Size(widget.size.width, widget.size.height * 0.1),
              content: "Email",
              onTap: widget.onTap,
            ),
            SizedBox(height: widget.size.height * 0.01),
            InputPanelT1(
              controller: passwordCtrl,
              size: Size(widget.size.width, widget.size.height * 0.1),
              content: "Password",
              onTap: widget.onTap,
            ),
            SizedBox(
              width: widget.size.width * 0.8,
              height: widget.size.height * 0.05,
              child: ForgetBox(
                size: Size(widget.size.width, widget.size.height * 0.05),
              ),
            ),
            LoginButton(
              size: Size(widget.size.width * 0.5, widget.size.height * 0.05),
              emailCtrl: emailCtrl,
              passwordCtrl: passwordCtrl,
            ),
            SizedBox(height: widget.size.height * 0.02),
            ExtraLogin(
              size: Size(widget.size.width, widget.size.height * 0.25),
            ),
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
