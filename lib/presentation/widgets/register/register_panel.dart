import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/loading_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/common/input_panel_t1.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/register/extra_login.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/register/sign_button.dart';

class RegisterPanel extends StatefulWidget {
  final Size size;
  const RegisterPanel({super.key, required this.size});

  @override
  State<RegisterPanel> createState() => _RegisterPanelState();
}

class _RegisterPanelState extends State<RegisterPanel> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void toggleLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  void stopLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWrapper(
      isLoading: _isLoading,
      child: Container(
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
              ),
              SizedBox(height: widget.size.height * 0.01),
              InputPanelT1(
                controller: passwordCtrl,
                size: Size(widget.size.width, widget.size.height * 0.1),
                content: "Password",
              ),
              SizedBox(height: widget.size.height * 0.01),
              InputPanelT1(
                controller: confirmPasswordCtrl,
                size: Size(widget.size.width, widget.size.height * 0.1),
                content: "Confirm password",
              ),
              SizedBox(height: widget.size.height * 0.02),
              SignUpButton(
                size: Size(widget.size.width * 0.5, widget.size.height * 0.05),
                emailCtrl: emailCtrl,
                passwordCtrl: passwordCtrl,
                confirmPasswordCtrl: confirmPasswordCtrl,
                toggleLoading: toggleLoading,
                stopLoading: stopLoading,
              ),
              SizedBox(height: widget.size.height * 0.02),
              ExtraLogin(
                size: Size(widget.size.width, widget.size.height * 0.15),
              ),
            ],
          ),
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
