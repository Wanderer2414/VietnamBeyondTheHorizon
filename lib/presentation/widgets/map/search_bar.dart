import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/map/map_controller.dart';

class SearchBarWidget extends StatelessWidget {
  final MyMapController controller;
  const SearchBarWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Enter a location',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              final location = controller.searchController.text.trim();
              if (location.isNotEmpty) {
                controller.fetchCoordinates(location);
              }
            },
          ),
        ],
      ),
    );
  }
}
