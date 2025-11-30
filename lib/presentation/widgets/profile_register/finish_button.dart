import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/data/models/city_map.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/proxy/proxy.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/loading_screen.dart';

class FinishButton extends StatefulWidget {
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
  State<FinishButton> createState() => _FinishButtonState();
}

class _FinishButtonState extends State<FinishButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final name = widget.name.trim();
        final age = widget.age!;
        final cityCode = widget.cityCode!;
        LoadingManager.run(context, (context) async {
          try {
            NetworkProxy.updateProfile(
              name,
              age,
              cityMap[cityCode] ?? "Unknown",
            );
            Navigator.of(context).pushReplacementNamed("home");
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Update profile failed: $e")),
            );
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
