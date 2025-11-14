import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/profile/stat_card.dart';

class StatPanel extends StatelessWidget {
  const StatPanel();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Statcard(
            value: '12',
            label: 'stars',
            icon: Icons.star,
            iconColor: Colors.amber,
          ),
          Statcard(
            value: '34',
            label: 'km long',
            icon: null,
            iconColor: Colors.blueGrey,
          ),
          Statcard(
            value: '3',
            label: 'missions\ncompleted',
            icon: null,
            iconColor: Colors.green,
          ),
        ],
      ),
    );
  }
}
