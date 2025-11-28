import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vietnambeyondthehorizon/data/models/city_map.dart';
import 'package:vietnambeyondthehorizon/data/user/user_account.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/auth_controller.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/loading_screen.dart';

class FinishButton extends ConsumerStatefulWidget {
  final Size size;
  final String name;
  final int? age;
  final int? cityCode;
  const FinishButton({
    super.key,
    required this.age,
    required this.name,
    required this.cityCode,
    required this.size,
  });

  @override
  ConsumerState<FinishButton> createState() => _FinishButtonState();
}

class _FinishButtonState extends ConsumerState<FinishButton> {
  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authProvider);
    final user = ref.watch(userProvider);
    return ElevatedButton(
      onPressed: () async {
        LoadingManager.show();

        final name = widget.name.trim();
        final age = widget.age!;
        final cityCode = widget.cityCode!;
        try {
          await auth.updateProfile(
            name: name,
            age: age,
            city: cityMap[cityCode] ?? "Unknown",
          );
          DateTime todayDateOnly = DateTime.now();
          ref
              .read(userProvider.notifier)
              .updateUser(
                user!.copyWith(
                  username: name,
                  age: age,
                  city: cityMap[cityCode],
                  createdAt: DateTime(
                    todayDateOnly.year,
                    todayDateOnly.month,
                    todayDateOnly.day,
                  ),
                ),
              );
          Navigator.of(context).pushReplacementNamed("home");
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Update profile failed: $e")));
        } finally {
          LoadingManager.hide();
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
            colors: [Color(0xFFFA6C6F), Color(0xFFD99100)],
            begin: AlignmentGeometry.xy(-2.5, 0),
            end: AlignmentGeometry.xy(1, 0),
          ),
          borderRadius: BorderRadius.circular(30),
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
            "Finish",
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
