import 'package:flutter/material.dart';

class SkipButton extends StatelessWidget {
  final void Function() onPressed;
  const SkipButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: this.onPressed,
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
