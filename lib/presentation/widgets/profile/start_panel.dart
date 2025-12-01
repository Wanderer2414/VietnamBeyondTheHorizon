import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/user_history.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/profile/stat_card.dart';

class StatPanel extends StatelessWidget {
  const StatPanel();

  @override
  Widget build(BuildContext context) {
    final missions_completed = UserHistoryManager().completedMissionIds.length
        .toString();
    final numberOfPhotos = UserHistoryManager().historyPhotos.length.toString();
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
            value: numberOfPhotos,
            label: 'photos',
            icon: null,
            iconColor: Colors.blueGrey,
          ),
          Statcard(
            value: missions_completed,
            label: 'missions\ncompleted',
            icon: null,
            iconColor: Colors.green,
          ),
        ],
      ),
    );
  }
}
