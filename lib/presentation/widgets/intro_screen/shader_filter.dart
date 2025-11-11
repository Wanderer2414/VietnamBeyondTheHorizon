import 'package:flutter/material.dart';

class ShadowFilter extends StatelessWidget {
  const ShadowFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white24, Colors.black87],
          begin: AlignmentGeometry.xy(0, -1),
          end: AlignmentGeometry.xy(0, 0.2),
        ),
      ),
    );
  }
}
