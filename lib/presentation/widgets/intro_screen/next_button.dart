import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  final Size size;
  final void Function() onPressed;
  const NextButton({super.key, required this.size, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD99100),
        foregroundColor: Colors.white,
        padding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        fixedSize: size,
        elevation: 6,
      ),
      child: const Text(
        'NEXT',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
