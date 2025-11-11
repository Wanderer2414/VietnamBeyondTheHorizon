import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/data/models/mission_model.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/photo.dart';

class ChallengeBoxWidget extends StatelessWidget {
  final MissionModel mission;
  const ChallengeBoxWidget({super.key, required this.mission});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return mission.illustrationURL != null
                    ? PhotoWidget(
                        mission.illustrationURL!,
                        width: constraints.maxWidth,
                        //height: 100,
                        borderRadius: 8,
                      )
                    : SizedBox();
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Text(
              mission.description,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            decoration: BoxDecoration(color: Colors.yellow[100]),
          ),

          // SizedBox(height: 4),
          // Text('Reward: ${mission.reward}'),
          // SizedBox(height: 4),
          // Text(
          //   mission.isCompleted
          //       ? 'Completed on ${mission.finishDay?.toLocal().toShortDateString()}'
          //       : 'Not completed',
          // ),
        ],
      ),
    );
  }
}
