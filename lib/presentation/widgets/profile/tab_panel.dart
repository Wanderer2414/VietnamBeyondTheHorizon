import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/profile/tab_button.dart';

class TabPanel extends StatelessWidget {
  final Function(int) onTap;
  final int selectedIndex;
  const TabPanel({this.selectedIndex = 0, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TabButton(
              icon: Icons.person,
              isSelected: selectedIndex == 0,
              onTap: () {
                onTap(0);
              },
            ),
          ),
          Expanded(
            child: TabButton(
              icon: Icons.grid_on,
              isSelected: selectedIndex == 1,
              onTap: () {
                onTap(1);
              },
            ),
          ),
        ],
      ),
    );
  }
}
