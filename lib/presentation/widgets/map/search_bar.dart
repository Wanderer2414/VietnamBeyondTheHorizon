import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/map_controller.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/common/textbox_t2.dart';

class SearchBarWidget extends StatefulWidget {
  final MyMapController controller;
  final Function() onTap;
  final Size size;
  SearchBarWidget({
    super.key,
    required this.controller,
    required this.size,
    required this.onTap,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextboxT2 _searchText;
  String _location = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _searchText = TextboxT2(
      size: Size(widget.size.width * 0.9, widget.size.height),
      hint: "Enter a location",
      onTap: widget.onTap,
      onUpdate: (value) => _location = value.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          _searchText,
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              if (_location.isNotEmpty) {
                widget.controller.fetchCoordinates(context, _location).then((
                  value,
                ) {
                  widget.onTap();
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
