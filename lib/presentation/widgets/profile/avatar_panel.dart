import 'package:flutter/material.dart';

class AvatarPanel extends StatelessWidget {
  const AvatarPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const CircleAvatar(
        radius: 56,
        backgroundColor: Color(0xFFE8E8E8),
        child: Icon(Icons.person, size: 56, color: Colors.grey),
      ),
    );
  }
}
