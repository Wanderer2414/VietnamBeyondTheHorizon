import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/intro_screen/background.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/intro_screen/bottom_box.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/intro_screen/bottom_content.dart';
import 'package:vietnambeyondthehorizon/routes/main_route.dart';

class _FirstTitle extends StatelessWidget {
  const _FirstTitle();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentGeometry.bottomCenter,
      child: RichText(
        textAlign: TextAlign.left,
        text: const TextSpan(
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: 'Discover Vietnam\n',
              style: TextStyle(
                color: Color(0xFFD4A428),
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: 'in a Whole New Way!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecondTitle extends StatelessWidget {
  const _SecondTitle();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentGeometry.bottomCenter,
      child: RichText(
        textAlign: TextAlign.left,
        text: const TextSpan(
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),

          children: [
            TextSpan(
              text: 'Let Us Guide ',
              style: TextStyle(color: Colors.black),
            ),
            TextSpan(
              text: 'Your Journey',
              style: TextStyle(color: Color(0xFFD4A428)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThirdTitle extends StatelessWidget {
  const _ThirdTitle();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentGeometry.bottomCenter,
      child: RichText(
        textAlign: TextAlign.left,
        text: const TextSpan(
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: 'Complete ',
              style: TextStyle(color: Colors.black),
            ),
            TextSpan(
              text: 'Missions',
              style: TextStyle(color: Color(0xFFD4A428)),
            ),
            TextSpan(
              text: '.\nCollect ',
              style: TextStyle(color: Colors.black),
            ),
            TextSpan(
              text: 'Memories',
              style: TextStyle(color: Color(0xFFD4A428)),
            ),
            TextSpan(
              text: '.',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

// // class IntroScreen extends StatelessWidget {
// //   const IntroScreen({super.key});
// //   @override
// //   Widget build(BuildContext context) {
// //     return IntroScreenTemplate(
// //       index: 0,
// //       total: 3,
// //       title: _FirstTitle(),
// //       content:
// //           'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris efficitur ex sit amet elementum sagittis.',
// //       background: AssetImage("assets/backgrounds/introduce_first.jpeg"),
// //       skipRoute: TransitionRLPageRoute(nextScreen: LogNavigatorScreen()),
// //       nextRoute: TransitionRLPageRoute(nextScreen: _SecondScreen()),
// //     );
// //   }
// // }

// class _SecondScreen extends StatelessWidget {
//   const _SecondScreen();
//   @override
//   Widget build(BuildContext context) {
//     return IntroScreenTemplate(
//       index: 1,
//       total: 3,
//       title: _SecondTitle(),
//       content:
//           'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris efficitur ex sit amet elementum sagittis.',
//       background: AssetImage("assets/backgrounds/introduce_second.jpeg"),
//       skipRoute: TransitionRLPageRoute(nextScreen: LogNavigatorScreen()),
//       nextRoute: TransitionRLPageRoute(nextScreen: _ThirdScreen()),
//     );
//   }
// }

// class _ThirdScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return IntroScreenTemplate(
//       index: 2,
//       total: 3,
//       title: _ThirdTitle(),
//       content:
//           'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris efficitur ex sit amet elementum sagittis.',
//       background: AssetImage("assets/backgrounds/introduce_third.png"),
//       skipRoute: TransitionRLPageRoute(nextScreen: LogNavigatorScreen()),
//       nextRoute: TransitionRLPageRoute(nextScreen: LogNavigatorScreen()),
//     );
//   }
// }

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          OverflowBox(
            maxWidth: size.width * 5,
            child: ScrollBackground(size: size, currentIndex: _index),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomBox(
              screenSize: size,
              content: Container(
                width: size.width,
                height: size.height * 0.38,
                child: ScrollContent(index: _index, size: size),
              ),
              index: _index,
              total: 3,
              onNext: () {
                if (_index < 2) {
                  _index++;
                  setState(() {});
                } else
                  MainRoute.goNavigatorScreen();
              },
              onSkip: () => MainRoute.goNavigatorScreen(),
            ),
          ),
        ],
      ),
    );
  }
}

class ScrollBackground extends StatefulWidget {
  const ScrollBackground({
    super.key,
    required this.size,
    required this.currentIndex,
  });

  final Size size;
  final int currentIndex;

  @override
  State<ScrollBackground> createState() => _ScrollBackgroundState();
}

class _ScrollBackgroundState extends State<ScrollBackground> {
  _ScrollBackgroundState();
  double current = 0, _scale = 1, old = 0, percent = 0, _offset = 0;
  Timer? _timer;
  double distance = 1;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if ((current - widget.currentIndex).abs() > 0.01) {
      distance = (current - widget.currentIndex).abs();
      old = current;
      current = widget.currentIndex.toDouble();
      percent = 0;
      _offset = old;
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
        if (percent < 0.2) {
          _scale *= 0.98;
          percent += 0.02;
        } else if (percent < 0.7) {
          _offset = old + (percent - 0.2) / 0.5 * distance;
          percent += 0.05;
        } else if (percent < 0.9) {
          _scale /= 0.98;
          percent += 0.02;
          _offset = current;
        } else {
          _timer?.cancel();
          percent = 1;
          _scale = 1;
        }
        setState(() {});
      });
    }
    return Padding(
      padding: EdgeInsetsGeometry.only(left: (2 - _offset) * widget.size.width),
      child: Row(
        children: [
          Background(
            screenSize: Size(widget.size.width, widget.size.height),
            background: AssetImage("assets/backgrounds/introduce_first.jpeg"),
            scale: _scale,
          ),
          Background(
            screenSize: Size(widget.size.width, widget.size.height),
            background: AssetImage("assets/backgrounds/introduce_second.jpeg"),
            scale: _scale,
          ),
          Background(
            screenSize: Size(widget.size.width, widget.size.height),
            background: AssetImage("assets/backgrounds/introduce_third.png"),
            scale: _scale,
          ),
        ],
      ),
    );
  }
}

class ScrollContent extends StatefulWidget {
  const ScrollContent({super.key, required this.index, required this.size});
  final int index;
  final Size size;
  @override
  State<ScrollContent> createState() => _ScrollContentState();
}

class _ScrollContentState extends State<ScrollContent> {
  final List<String> text = [
    "Experience Vietnam beyond the typical tourist paths.\nFrom vibrant cities to hidden natural wonders, uncover stories, culture, and adventures waiting just for you.",
    "Navigate your travels with confidence.\nReceive personalized recommendations, must-see destinations, and helpful tips tailored to your interests.",
    "Turn every adventure into a fun challenge.\nComplete missions, earn rewards, and create unforgettable memories as you explore Vietnam like never before.",
  ];
  double distance = 0,
      current = 0,
      old = 0,
      percent = 0,
      _scale = 0,
      _offset = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if ((current - widget.index).abs() > 0.01) {
      distance = (current - widget.index).abs();
      old = current;
      current = widget.index.toDouble();
      percent = 0;
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
        if (percent < 0.95) {
          percent += 0.02;
        } else {
          _timer?.cancel();
          percent = 1;
        }
        setState(() {});
      });
    }
    Widget? childs;
    switch (_offset.floor()) {
      case 0:
        childs = _FirstTitle();
        break;
      case 1:
        childs = _SecondTitle();
        break;
      case 2:
        childs = _ThirdTitle();
        break;
      default:
    }
    _scale = percent;
    if (_scale > 0.5) _scale = 1 - percent;
    return Column(
      children: [
        Container(
          width: widget.size.width * 0.85,
          height: widget.size.height * 0.17,
          padding: EdgeInsets.only(top: _scale * widget.size.height * 0.5),
          child: childs,
        ),
        SizedBox(height: 20),
        BottomContent(
          content: text[widget.index],
          size: Size(widget.size.width * 0.7, widget.size.height * 0.15),
          padding: EdgeInsets.only(bottom: _scale * widget.size.height * 0.5),
        ),
      ],
    );
  }
}
