import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/data/packages/reccommend_scenic.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/video_screen.dart';

class ScenicPanel extends StatefulWidget {
  final Size size;
  final Reccommendscenic package;
  const ScenicPanel({super.key, required this.size, required this.package});
  @override
  State<ScenicPanel> createState() => ScenicPanelState();
}

class ScenicPanelState extends State<ScenicPanel> {
  double scale = 1;
  void setScale(double scale) {
    setState(() {
      this.scale = scale;
    });
  }

  void watchRecapVideo(BuildContext context) {
    final videoUrls = widget.package.videoUrl;
    if (videoUrls != null) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => VideoApp(path: videoUrls)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => watchRecapVideo(context),
      child: Container(
        width: widget.size.width,
        height: widget.size.height,
        alignment: Alignment.bottomCenter,
        child: Container(
          width: widget.size.width * scale,
          height: widget.size.height * scale,

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(blurRadius: 5, color: Color(0x4B000000)),
            ],
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: widget.package.image,
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              Container(
                width: widget.size.width,
                height: widget.size.height,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(0, 0, 0, 0),
                      Color.fromARGB(150, 0, 0, 0),
                    ],
                  ),
                ),
                alignment: Alignment.bottomCenter,
              ),
              Container(
                width: widget.size.width,
                height: widget.size.height,
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.only(
                  left: widget.size.width * 0.1,
                  bottom: widget.size.height * 0.03,
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.package.name,
                        style: const TextStyle(
                          fontFamily: "Jost",
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -2,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        // "${widget.package.establishedTime.day}/${widget.package.establishedTime.month}/${widget.package.establishedTime.year}",
                        "",
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
      ),
    );
  }
}
