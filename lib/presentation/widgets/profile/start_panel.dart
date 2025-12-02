import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/profile/stat_card.dart';

class StatPanel extends StatelessWidget {
  final int numberOfPhotos, missions_completed;
  const StatPanel({
    required this.missions_completed,
    required this.numberOfPhotos,
  });

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
            value: numberOfPhotos.toString(),
            label: 'photos',
            icon: null,
            iconColor: Colors.blueGrey,
          ),
          Statcard(
            value: missions_completed.toString(),
            label: 'missions\ncompleted',
            icon: null,
            iconColor: Colors.green,
          ),
        ],
      ),
    );
  }
}
