import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vietnambeyondthehorizon/data/user/user_account.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/profile/intro_item.dart';

class InfoView extends ConsumerStatefulWidget {
  const InfoView({super.key});

  @override
  ConsumerState<InfoView> createState() => _InfoViewState();
}

class _InfoViewState extends ConsumerState<InfoView> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoItem(label: 'E-mail', value: user!.email),
          const SizedBox(height: 24),
          InfoItem(
            label: 'Member since',
            value:
                "${user.createdAt!.year}-${user.createdAt!.month}-${user.createdAt!.day}",
          ),
          const SizedBox(height: 24),
          InfoItem(label: 'Age', value: user.age.toString()),
        ],
      ),
    );
  }
}
