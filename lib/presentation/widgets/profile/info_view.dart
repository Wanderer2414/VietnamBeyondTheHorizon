import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/data/user/user_account.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/profile/intro_item.dart';

class InfoView extends StatefulWidget {
  final UserAccount account;
  const InfoView({super.key, required this.account});

  @override
  State<InfoView> createState() => _InfoViewState();
}

class _InfoViewState extends State<InfoView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoItem(label: 'E-mail', value: widget.account.email),
          const SizedBox(height: 24),
          InfoItem(
            label: 'Member since',
            value:
                "${widget.account.createdAt!.year}-${widget.account.createdAt!.month}-${widget.account.createdAt!.day}",
          ),
          const SizedBox(height: 24),
          InfoItem(label: 'Age', value: widget.account.age.toString()),
        ],
      ),
    );
  }
}
