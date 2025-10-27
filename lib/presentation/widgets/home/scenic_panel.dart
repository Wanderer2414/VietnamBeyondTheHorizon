import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/data/packages/reccommend_scenic.dart';

class ScenicPanel extends StatelessWidget {
  final Size size;
  final double scale;
  final Reccommendscenic package;
  const ScenicPanel({
    super.key,
    required this.size,
    required this.package,
    this.scale = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      alignment: Alignment.bottomCenter,
      child: Container(
        width: size.width * scale,
        height: size.height * scale,

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [BoxShadow(blurRadius: 5, color: Color(0x4B000000))],
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: package.image, fit: BoxFit.fill),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Container(
              width: size.width,
              height: size.height,
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(
                left: size.width * 0.1,
                bottom: size.height * 0.03,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      package.name,
                      style: const TextStyle(
                        fontFamily: "Jost",
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -2,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "${package.establishedTime.day}/${package.establishedTime.month}/${package.establishedTime.year}",
                      style: const TextStyle(
                        fontFamily: "Jost",
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
