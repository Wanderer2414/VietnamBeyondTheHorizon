import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/data/user/user_account.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/network_proxy.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/profile/intro_item.dart';

class InfoView extends StatefulWidget {
  const InfoView({super.key});

  @override
  State<InfoView> createState() => _InfoViewState();
}

class _InfoViewState extends State<InfoView> {
  UserAccount? user;
  @override
  void initState() {
    super.initState();
    NetworkProxy.account.then(
      (value) => setState(() {
        user = value;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoItem(label: 'E-mail', value: user?.email ?? ""),
          const SizedBox(height: 24),
          InfoItem(
            label: 'Member since',
            value:
                "${user?.createdAt!.year}-${user?.createdAt!.month}-${user?.createdAt!.day}",
          ),
          const SizedBox(height: 24),
          InfoItem(label: 'Age', value: user?.age.toString() ?? ""),
        ],
      ),
    );
  }
}
