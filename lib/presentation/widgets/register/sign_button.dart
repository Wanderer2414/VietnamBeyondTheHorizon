import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vietnambeyondthehorizon/animations/screen/transitionRL.dart';
import 'package:vietnambeyondthehorizon/data/user/user_account.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/auth_controller.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/profile_register_screen.dart';

class SignUpButton extends ConsumerStatefulWidget {
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
  ConsumerState<SignUpButton> createState() => _SignUpButtonState();
}

class _SignUpButtonState extends ConsumerState<SignUpButton> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authProvider);

    return ElevatedButton(
      onPressed: _loading
          ? null
          : () async {
              setState(() {
                _loading = true;
              });
              final email = widget.emailCtrl.text.trim();
              final password = widget.passwordCtrl.text.trim();
              final confirmPassword = widget.confirmPasswordCtrl.text.trim();

              try {
                await auth.signup(email, password, confirmPassword);
                if (!mounted) return;

                if (auth.isLoggedIn) {
                  final user = UserAccount(email: email);
                  ref.read(userProvider.notifier).setUser(user);
                  Navigator.of(
                    context,
                  ).push(TransitionRLPageRoute(nextScreen: ProfileRegister()));
                }
              } catch (e) {
                if (!mounted) return;

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Sign up failed: $e")));
              } finally {
                if (mounted)
                  setState(() {
                    _loading = false;
                  });
              }
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
            colors: _loading
                ? [Colors.grey.shade400, Colors.grey.shade500]
                : [Color(0xFFFA6C6F), Color(0xFFD99100)],
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
          child: _loading
              ? const CircularProgressIndicator(
                  color: Color.fromARGB(255, 0, 0, 0),
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Text(
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
