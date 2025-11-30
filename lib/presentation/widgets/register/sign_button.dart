import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/animations/screen/transition.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/proxy/proxy.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/loading_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/profile_register_screen.dart';

class SignUpButton extends StatefulWidget {
  final Size size;
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final TextEditingController confirmPasswordCtrl;
  const SignUpButton({
    super.key,
    required this.size,
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.confirmPasswordCtrl,
  });

  @override
  State<SignUpButton> createState() => _SignUpButtonState();
}

class _SignUpButtonState extends State<SignUpButton> {
  @override
  Widget build(BuildContext context) {
    // final auth = ref.read(authProvider);

    return ElevatedButton(
      onPressed: () {
        final email = widget.emailCtrl.text.trim();
        final password = widget.passwordCtrl.text.trim();
        final confirmPassword = widget.confirmPasswordCtrl.text.trim();
        if (password != confirmPassword) return; // <- Update there
        LoadingManager.run(context, (context) async {
          try {
            if (await NetworkProxy.register(email, password)) {
              Navigator.of(
                context,
              ).push(TransitionRLPageRoute(nextScreen: ProfileRegister()));
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Sign up failed!")));
            }
          } catch (e) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Error $e!")));
          }
        });
      },
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
        shadowColor: WidgetStatePropertyAll(Colors.transparent),
        foregroundColor: WidgetStatePropertyAll(Colors.transparent),
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        padding: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return EdgeInsets.only(top: 4);
          } else {
            return EdgeInsets.only(top: 2, bottom: 2);
          }
        }),
      ),
      child: Container(
        width: widget.size.width,
        height: widget.size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFA6C6F), Color(0xFFD99100)],
            begin: AlignmentGeometry.xy(-2.5, 0),
            end: AlignmentGeometry.xy(1, 0),
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 3.8),
              blurRadius: 2,
              color: Colors.black26,
            ),
          ],
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "Sign up",
            style: TextStyle(
              fontFamily: "Jost",
              fontWeight: FontWeight.w300,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
