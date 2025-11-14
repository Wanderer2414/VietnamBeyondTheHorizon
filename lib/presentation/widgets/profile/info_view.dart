import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/profile/intro_item.dart';

class InfoView extends StatelessWidget {
  const InfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoItem(label: 'E-mail', value: 'nguyenvana@example.com'),
          const SizedBox(height: 24),
          InfoItem(label: 'Member since', value: '29 Dec, 2025'),
          const SizedBox(height: 24),
          InfoItem(label: 'Age', value: '20'),
        ],
      ),
    );
  }
}
