import 'package:flutter/material.dart';

class SkipButton extends StatelessWidget {
  final Route skipRoute;
  const SkipButton({super.key, required this.skipRoute});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushReplacement(skipRoute);
      },
      child: const Text(
        'SKIP',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
