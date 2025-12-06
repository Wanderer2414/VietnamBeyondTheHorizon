import 'package:flutter/material.dart';

class TabButton extends StatelessWidget {
  const TabButton({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.black : Colors.transparent,
              width: 2.5,
            ),
          ),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.black : Colors.grey[400],
          size: 28,
        ),
      ),
    );
  }
}
