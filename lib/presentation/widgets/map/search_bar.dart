import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/map_controller.dart';

class SearchBarWidget extends ConsumerWidget {
  final MyMapController controller;
  final StateProvider<bool> provider;
  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.provider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
                FocusScope.of(context).setFirstFocus(FocusScopeNode());
              },
              controller: controller.searchController,
              autofocus: false,
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
                controller.fetchCoordinates(location).then((value) {
                  if (value)
                    ref.read(provider.notifier).state = !ref
                        .read(provider.notifier)
                        .state;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
