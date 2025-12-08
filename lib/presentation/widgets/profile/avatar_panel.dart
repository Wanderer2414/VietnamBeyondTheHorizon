import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/profile_register/avatar.dart';

class AvatarPanel extends StatelessWidget {
  final String? currentAvatarUrl;
  const AvatarPanel(this.currentAvatarUrl);

  @override
  Widget build(BuildContext context) {
    double radius = 56;
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
      child: AvatarWidget(
        radius: radius,
        onClick: true,
        currentAvatarUrl: currentAvatarUrl,
      ),
    );
  }
}
