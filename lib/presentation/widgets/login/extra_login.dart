import 'package:flutter/material.dart';

class ExtraLogin extends StatelessWidget {
  final Size size;
  const ExtraLogin({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.8,
      height: size.height,
      padding: EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _Decoration(size: size),
          SizedBox(
            width: size.width,
            height: size.height * 0.3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ExtraLoginButton(radius: size.height * 0.22),
                SizedBox(width: size.width * 0.1),
                _ExtraLoginButton(radius: size.height * 0.22),
                SizedBox(width: size.width * 0.1),
                _ExtraLoginButton(radius: size.height * 0.22),
              ],
            ),
          ),
          _SignUpNavigate(size: size),
        ],
      ),
    );
  }
}

class _ExtraLoginButton extends StatelessWidget {
  final double radius;
  const _ExtraLoginButton({required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black26),
      child: null,
    );
  }
}

class _SignUpNavigate extends StatelessWidget {
  const _SignUpNavigate({required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height * 0.25,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account? ",
              style: TextStyle(fontFamily: "Jost", color: Colors.black38),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("register");
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(2),
                ),
                minimumSize: Size(size.width * 0.1, size.height * 0.1),
                maximumSize: Size(size.width * 0.15, size.height * 0.15),
              ),
              child: Text(
                "Sign up",
                style: TextStyle(color: Color(0xFF1295FF), fontFamily: "Jost"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Decoration extends StatelessWidget {
  const _Decoration({required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _LogInDivider(size: size),
        _LoginWithLabel(size: size),
      ],
    );
  }
}

class _LoginWithLabel extends StatelessWidget {
  const _LoginWithLabel({required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.13,
      alignment: Alignment.topCenter,
      child: Container(
        width: size.width * 0.25,
        decoration: BoxDecoration(color: Colors.white),
        alignment: Alignment.center,
        child: Text(
          "Log in with",
          style: TextStyle(
            fontFamily: "Jost",
            color: Colors.black38,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class _LogInDivider extends StatelessWidget {
  const _LogInDivider({required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.8,
      height: size.height * 0.1,
      padding: EdgeInsets.only(top: 5),
      child: Divider(
        color: Colors.black38,
        thickness: 2,
        indent: size.width * 0.03,
        endIndent: size.width * 0.03,
      ),
    );
  }
}
