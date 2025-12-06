import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/data/models/mission_model.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/photo.dart';

class ChallengeBoxWidget extends StatelessWidget {
  final MissionModel mission;
  const ChallengeBoxWidget({super.key, required this.mission});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white.withOpacity(0.9), // Nền trắng hơi trong suốt
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (mission.illustrationURL != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: PhotoWidget(
                    mission.illustrationURL!,
                    width: double.infinity,
                    height: 150,
                  ),
                ),
              ),

            _buildSectionTitle(Icons.description, "Description", Colors.blue),
            SizedBox(height: 5),
            Text(
              mission.context,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.3,
              ),
            ),

            SizedBox(height: 15),
            _buildSectionTitle(
              Icons.flag_rounded,
              "Challenge",
              Colors.redAccent,
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      mission.challenge,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 15),
            _buildSectionTitle(
              Icons.card_giftcard,
              "Reward",
              Colors.amber[700]!,
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  mission.difficulty.toString(),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.amber[900],
                  ),
                ),

                SizedBox(width: 8),
                Icon(
                  Icons.star_rate_rounded,
                  color: const Color.fromARGB(255, 252, 233, 60),
                  size: 25,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}
