import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/retry.dart';
import 'package:vietnambeyondthehorizon/data/user/user_account.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/auth_controller.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/loading_screen.dart';

class LoginButton extends ConsumerStatefulWidget {
  final Size size;
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  const LoginButton({
    super.key,
    required this.size,
    required this.emailCtrl,
    required this.passwordCtrl,
  });

  @override
  ConsumerState<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends ConsumerState<LoginButton> {
  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return ElevatedButton(
      onPressed: () async {
        LoadingManager.show();
        final email = widget.emailCtrl.text.trim();
        final password = widget.passwordCtrl.text.trim();
        try {
          await auth.login(email, password);
          try {
            final user = await auth.fetchUserData();
            if (user != null) {
              if (!mounted) return;

              ref.read(userProvider.notifier).setUser(user);
              print("Fetch data successfully!");
            }
          } catch (e) {
            print("Fetch user failed: $e");
          }
          if (!mounted) return;
          if (auth.isLoggedIn) {
            print("Move to Home");
            Navigator.of(context).pushReplacementNamed("home");
          }
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Login failed: $e")));
        } finally {
          LoadingManager.hide();
        }
      },

      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.transparent),
        shadowColor: MaterialStatePropertyAll(Colors.transparent),
        foregroundColor: MaterialStatePropertyAll(Colors.transparent),
        overlayColor: MaterialStatePropertyAll(Colors.transparent),
        padding: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
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
            begin: Alignment(-2.5, 0),
            end: Alignment(1, 0),
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
            "Log in",
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
