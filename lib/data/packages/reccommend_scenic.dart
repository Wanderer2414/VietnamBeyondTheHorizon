import 'package:flutter/widgets.dart';

class Reccommendscenic {
  final ImageProvider<Object> image;
  final String name;
  final DateTime establishedTime;
  final videoUrl;
  const Reccommendscenic({
    required this.image,
    required this.name,
    required this.establishedTime,
    required this.videoUrl,
  });
}
