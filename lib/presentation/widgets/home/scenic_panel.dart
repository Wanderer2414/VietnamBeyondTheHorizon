import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/data/packages/reccommend_scenic.dart';

class ScenicPanel extends StatelessWidget {
  final Size size;
  final Reccommendscenic package;
  const ScenicPanel({super.key, required this.size, required this.package});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(blurRadius: 5, color: Color.fromRGBO(0, 0, 0, 0.3)),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 15),
          Container(
            width: size.width * 0.88,
            height: size.height * 0.6,
            decoration: BoxDecoration(
              image: DecorationImage(image: package.image),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(height: 10),
          Text(
            package.name,
            style: TextStyle(fontFamily: "Jost", fontSize: 16),
          ),
          Text(
            "${package.establishedTime.day}/${package.establishedTime.month}/${package.establishedTime.year}",
            style: TextStyle(fontFamily: "Jost", fontSize: 14),
          ),
        ],
      ),
    );
  }
}
