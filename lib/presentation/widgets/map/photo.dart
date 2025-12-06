import 'package:flutter/material.dart';

class PhotoWidget extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final double? borderRadius;
  const PhotoWidget(
    this.url, {
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => Dialog(
            backgroundColor: Colors.transparent,
            child: Hero(
              tag: url,
              child: InteractiveViewer(
                clipBehavior: Clip.none,
                child: Image.network(url),
              ),
            ),
          ),
        );
      },
      child: Hero(
        tag: url,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius ?? 0),
          child: Image.network(
            url,
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
