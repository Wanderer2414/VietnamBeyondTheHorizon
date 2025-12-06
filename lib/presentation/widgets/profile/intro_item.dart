import 'package:flutter/material.dart';

class InfoItem extends StatelessWidget {
  const InfoItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFFFFB088),
            fontFamily: 'Courier',
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Courier',
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
