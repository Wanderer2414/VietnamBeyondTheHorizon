import 'package:flutter/material.dart';

class DescriptionBox extends StatelessWidget {
  final String description;
  const DescriptionBox({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Description", style: TextStyle(fontSize: 15)),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 30),
          child: Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris efficitur ex sit amet elementum sagittis. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris efficitur ex sit amet elementum sagittis.",
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
