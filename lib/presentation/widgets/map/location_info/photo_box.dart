import 'package:flutter/material.dart';

class PhotoBoxWidget extends StatelessWidget {
  final List<String> imageURLs;
  const PhotoBoxWidget({super.key, required this.imageURLs});

  Widget _buildPhoto(String path) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(image: AssetImage(path), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildPhotoFromNetwork(String path) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(image: NetworkImage(path), fit: BoxFit.cover),
      ),
    );
  }

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
              return _buildPhotoFromNetwork(url);
            }).toList(),
          ),
        ),
      ],
    );
  }
}
