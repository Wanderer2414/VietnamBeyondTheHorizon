import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/profile/album_view.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/profile/info_view.dart';

class TabContentPanel extends StatelessWidget {
  const TabContentPanel({
    super.key,
    required int selectedIndex,
    required this.photos,
  }) : _selectedIndex = selectedIndex;

  final int _selectedIndex;
  final List<String> photos;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: _selectedIndex == 0 ? const Color(0xFFFFF9F0) : Colors.white,
        child: _selectedIndex == 0 ? InfoView() : AlbumView(photos: photos),
      ),
    );
  }
}
