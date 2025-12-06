import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/data/user/user_account.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/profile/album_view.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/profile/info_view.dart';

class TabContentPanel extends StatelessWidget {
  const TabContentPanel({
    super.key,
    required int selectedIndex,
    required this.account,
  }) : _selectedIndex = selectedIndex;

  final int _selectedIndex;
  final UserAccount account;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: _selectedIndex == 0 ? const Color(0xFFFFF9F0) : Colors.white,
        child: _selectedIndex == 0
            ? InfoView(account: account)
            : AlbumView(photos: account.Photos),
      ),
    );
  }
}
