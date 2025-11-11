import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/map_controller.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/common/textbox_t2.dart';

class SearchBarWidget extends ConsumerWidget {
  final MyMapController controller;
  final StateProvider<bool> provider;
  final StateProvider<String> _searchTextProvider = StateProvider((ref) => "");
  final Function()? onTap;
  final Size size;
  SearchBarWidget({
    super.key,
    required this.controller,
    required this.provider,
    required this.size,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          TextboxT2(
            size: Size(size.width * 0.9, size.height),
            hint: "Enter a location",
            provider: _searchTextProvider,
            onTap: onTap,
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              final location = ref.watch(_searchTextProvider).trim();
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
