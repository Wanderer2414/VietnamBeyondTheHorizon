import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/data/packages/reccommend_scenic.dart';

class HomeStation extends StatelessWidget {
  const HomeStation({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: screenSize.height * 0.09,
        actionsPadding: EdgeInsets.only(bottom: screenSize.height * 0.01),
        actions: [
          HomeUpBar(size: Size(screenSize.width, screenSize.height * 0.08)),
        ],
      ),
      body: Stack(
        children: [
          CustomPaint(
            size: Size(screenSize.width, screenSize.height),
            painter: Decoration(),
          ),

          Column(
            children: [
              SizedBox(height: screenSize.height * 0.03),
              //Hi box
              GreetingBox(
                size: Size(screenSize.width * 0.9, screenSize.height * 0.15),
                userName: "Quoc Huy",
              ),
              SizedBox(height: screenSize.height * 0.03),

              //Daily box
              DailyBox(
                size: Size(screenSize.width * 0.9, screenSize.height * 0.19),
              ),

              SizedBox(height: screenSize.height * 0.02),

              //Visited label
              Row(
                children: [
                  SizedBox(width: screenSize.width * 0.06),
                  Text(
                    "VISITED PLACES",
                    style: TextStyle(
                      fontFamily: "Jost",
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                ],
              ),

              //Scroll view of visited place
              VisitedPlaceBox(
                size: Size(screenSize.width * 0.9, screenSize.height * 0.4),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: HomeDownBar(
        size: Size(screenSize.width * 0.9, screenSize.height * 0.13),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}

class Decoration extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Gradient gradient = LinearGradient(
      colors: [
        Color.fromARGB(255, 0xFC, 0xF7, 0xBB),
        Color.fromARGB(255, 0xFF, 0x62, 0x62),
      ],
      begin: AlignmentGeometry.xy(-1.5, -1),
      end: AlignmentGeometry.xy(4, 1),
    );
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = gradient.createShader(rect);
    final Paint shadowPaint = Paint()
      ..color = Color.fromARGB(255, 0xD9, 0x91, 0)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final double radius = size.width * 1.3;
    final Offset center = Offset(size.width / 2, size.height * 0.45 - radius);

    canvas.drawCircle(center, radius, paint);

    canvas.drawCircle(center, radius - 3, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class RequestTask extends StatelessWidget {
  final Size size;
  final String content;
  final int reward;
  const RequestTask({
    super.key,
    required this.size,
    required this.content,
    required this.reward,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        fixedSize: size,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
        ),
      ),
      onPressed: () {},
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 0xFF, 0xFF, 0x7B),
              Color.fromARGB(255, 0xFF, 0x95, 00),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Color.fromRGBO(0, 0, 0, 0.5),
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          children: [
            SizedBox(width: size.width * 0.02),
            Container(
              width: size.height * 0.5,
              height: size.height * 0.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/icons/camera-icon.png"),
                ),
              ),
            ),
            Spacer(),
            Center(
              child: Text(
                content,
                style: TextStyle(fontFamily: "Inder", fontSize: 17),
              ),
            ),
            Spacer(),
            Container(
              width: size.width * 0.22,
              height: size.height * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                color: Color.fromARGB(255, 0xCB, 0xE2, 0xB0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: size.height * 0.25,
                    height: size.height * 0.25,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/icons/diamond-icon.png"),
                      ),
                    ),
                  ),
                  Text(
                    " x $reward",
                    style: TextStyle(fontFamily: "Inder", fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}

class GreetingBox extends StatelessWidget {
  final Size size;
  final String userName;
  const GreetingBox({super.key, required this.size, required this.userName});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            blurStyle: BlurStyle.outer,
            blurRadius: 3,
            spreadRadius: 0,
            color: Color.fromRGBO(0, 0, 0, 0.5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsetsGeometry.only(top: 15, left: 20),
              child: Text(
                "Hi",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "KronaOne",
                  fontSize: 26,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsetsGeometry.only(bottom: 15, left: 20),
              child: Text(
                userName,
                maxLines: 1,
                softWrap: false,
                style: TextStyle(
                  color: Color.fromARGB(255, 0x1E, 0x17, 0x62),
                  fontFamily: "KronaOne",
                  fontSize: 26,
                  letterSpacing: -1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DailyBox extends StatelessWidget {
  final Size size;
  const DailyBox({super.key, required this.size});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            blurStyle: BlurStyle.outer,
            blurRadius: 3,
            spreadRadius: 0,
            color: Color.fromRGBO(0, 0, 0, 0.5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsGeometry.only(top: 10, left: 20),
            child: Text(
              "Daily Quest",
              style: TextStyle(
                color: Colors.black,
                fontFamily: "Inder",
                fontSize: 31,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.05),
          Center(
            child: RequestTask(
              size: Size(size.width * 0.9, size.height * 0.4),
              content: "Visit 3 locations",
              reward: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeUpBar extends StatelessWidget {
  final Size size;
  const HomeUpBar({super.key, required this.size});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 0xFF, 0x95, 00),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 1,
            spreadRadius: 1,
            color: Color.fromRGBO(0, 0, 0, 0.3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: size.width * 0.03),
              SideBarButton(side: size.height * 0.7),
              Spacer(),
              GemsBox(size: Size(size.width * 0.12, size.height / 2 / 1.5)),
              SizedBox(width: size.width * 0.06),
              StarsBox(size: Size(size.width * 0.12, size.height / 2 / 1.5)),
              SizedBox(width: size.width * 0.1),
            ],
          ),
        ],
      ),
    );
  }
}

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

class VisitedPlaceBox extends StatelessWidget {
  final Size size;
  const VisitedPlaceBox({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    ScrollController scrollbar = ScrollController();
    return Container(
      width: size.width,
      height: size.height,
      alignment: Alignment.topCenter,
      child: Scrollbar(
        controller: scrollbar,
        child: SingleChildScrollView(
          controller: scrollbar,
          scrollDirection: Axis.horizontal,
          child: Container(
            height: size.height,
            padding: EdgeInsets.all(5),
            child: Row(
              spacing: 10,
              children: List.generate(10, (index) {
                return ScenicPanel(
                  size: Size(size.width * 0.5, size.height * 0.85),
                  package: Reccommendscenic(
                    image: AssetImage(
                      "assets/temporary/lorem-ipsum-small-background.png",
                    ),
                    name: "Lorem ipsum",
                    establishedTime: DateTime(2022, 20, 19),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeDownBar extends StatelessWidget {
  final Size size;
  const HomeDownBar({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final double spacing =
        (size.width - size.height * (5.0 / 3 + 0.7 + 0.4)) / 4;
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(),
      child: Stack(
        children: [
          CustomPaint(
            size: Size(size.width, size.height),
            painter: HomeDownBarDecoration(),
          ),
          Column(
            children: [
              SizedBox(height: size.height * 0.24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HomeButton(radius: size.height / 2),
                  SizedBox(width: spacing),
                  RankingButton(radius: size.height / 2 / 1.2),
                  SizedBox(width: spacing),
                  PlayButton(radius: size.height / 2 * 1.4),
                  SizedBox(width: spacing),
                  HeartButton(radius: size.height / 2 / 1.2),
                  SizedBox(width: spacing),
                  UserButton(radius: size.height / 2 / 1.2),
                  SizedBox(width: size.height / 12),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PlayButton extends StatelessWidget {
  final double radius;
  const PlayButton({super.key, required this.radius});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: CircleBorder(),
        fixedSize: Size(radius, radius),
      ),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              spreadRadius: 2,
              offset: Offset(0, 2),
              color: Color.fromRGBO(0, 0, 0, 0.4),
            ),
          ],
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage("assets/icons/gamepad.png"),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeButton extends StatelessWidget {
  final double radius;
  const HomeButton({super.key, required this.radius});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.zero,
        minimumSize: Size.square(radius / 2),
        maximumSize: Size.square(radius),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      child: Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/icons/home.png"),
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
    );
  }
}

class RankingButton extends StatelessWidget {
  final double radius;
  const RankingButton({super.key, required this.radius});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
        ),
        padding: EdgeInsets.zero,
        minimumSize: Size.square(radius / 2),
        maximumSize: Size.square(radius),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      child: Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/icons/ranking-star.png"),
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
    );
  }
}

class HeartButton extends StatelessWidget {
  final double radius;
  const HeartButton({super.key, required this.radius});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        minimumSize: Size.square(radius / 2),
        maximumSize: Size.square(radius),
        padding: EdgeInsets.all(3),
      ),

      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/icons/heart.png")),
        ),
      ),
    );
  }
}

class UserButton extends StatelessWidget {
  final double radius;
  const UserButton({super.key, required this.radius});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        minimumSize: Size.square(radius / 2),
        maximumSize: Size.square(radius),
        padding: EdgeInsets.zero,
      ),

      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/icons/user.png")),
        ),
      ),
    );
  }
}

class GemsBox extends StatelessWidget {
  final Size size;
  const GemsBox({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width + size.height / 2.3,
      height: size.height * 1.8,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(20, 20, 20, 0.7),
                    blurRadius: 5,
                    offset: Offset(-1, -1),
                    blurStyle: BlurStyle.inner,
                  ),
                  BoxShadow(
                    color: Color.alphaBlend(
                      Color.fromRGBO(0, 0, 0, 0.36),
                      Color.fromARGB(255, 0xFF, 0x95, 00),
                    ),
                    // offset: Offset(0, 3),
                    blurRadius: 2,
                    spreadRadius: -2.0,
                    // blurStyle: BlurStyle.outer,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft.add(
              AlignmentGeometry.xy(0, size.height * 0.02),
            ),
            child: Transform.rotate(
              angle: -pi / 4,
              origin: Offset(0, size.height / 2),
              child: Container(
                width: size.height * 1.5,
                height: size.height * 1.5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/icons/diamond-icon.png"),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StarsBox extends StatelessWidget {
  final Size size;
  const StarsBox({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width + size.height,
      height: size.height * 1.8,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(20, 20, 20, 0.7),
                    blurRadius: 5,
                    offset: Offset(-1, -1),
                    blurStyle: BlurStyle.inner,
                  ),
                  BoxShadow(
                    color: Color.alphaBlend(
                      Color.fromRGBO(0, 0, 0, 0.36),
                      Color.fromARGB(255, 0xFF, 0x95, 00),
                    ),
                    blurRadius: 2,
                    spreadRadius: -2.0,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft.add(
              AlignmentGeometry.xy(0, size.height * 0.07),
            ),
            child: Container(
              width: size.height * 1.6,
              height: size.height * 1.6,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/icons/star.png"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SideBarButton extends StatelessWidget {
  final double side;
  const SideBarButton({super.key, required this.side});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},

      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        minimumSize: Size.square(side),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
        ),
      ),
      child: Container(
        width: side,
        height: side,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/icons/bar.png")),
        ),
      ),
    );
  }
}

class HomeDownBarDecoration extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Gradient gradient = LinearGradient(
      colors: [
        Color.fromARGB(255, 0xFA, 0x6C, 0x6F),
        Color.fromARGB(255, 0xD9, 0x91, 0),
      ],
      begin: AlignmentGeometry.xy(-2, 0.5),
      end: AlignmentGeometry.xy(1.8, 0.5),
    );
    final Paint paint = Paint()
      ..color = Colors.orange
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..style = PaintingStyle.fill;
    Path path = Path();
    // path.addOval(Rect.fromLTWH(0, 0, size.width, size.height));
    final double sideRadius = size.height / 4,
        middleRadius = sideRadius * 5 / 3,
        startY = size.height / 2;

    path.moveTo(sideRadius, startY);
    path.arcToPoint(
      Offset(sideRadius, size.height),
      radius: Radius.circular(sideRadius),
      clockwise: false,
    );
    path.lineTo(size.width - sideRadius, size.height);
    path.arcToPoint(
      Offset(size.width - sideRadius, startY),
      radius: Radius.circular(sideRadius),
      clockwise: false,
    );
    final double startX = sqrt(25 / 9 - 1 / 9) * sideRadius;
    path.lineTo(size.width / 2 + startX, startY);
    path.arcToPoint(
      Offset(size.width / 2 - startX, startY),
      radius: Radius.circular(middleRadius),
      clockwise: false,
    );
    path.lineTo(sideRadius * 2.2, startY);
    path.arcToPoint(
      Offset(sideRadius * 0.4, sideRadius * 0.4 + startY),
      radius: Radius.circular(sideRadius * 1.1),
      clockwise: false,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
