import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/photo.dart';

class PhotoBoxWidget extends StatelessWidget {
  final List<String> imageURLs;
  const PhotoBoxWidget({super.key, required this.imageURLs});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Photos", style: TextStyle(fontSize: 15)),
        SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: imageURLs.map((url) {
              return Container(
                margin: const EdgeInsets.only(right: 12),
                child: PhotoWidget(
                  url,
                  width: 120,
                  height: 120,
                  borderRadius: 8,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
