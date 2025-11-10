import 'package:flutter/material.dart';
import 'package:vietnam_beyond_the_horizon/animations/screen/transitionRL.dart';
import 'package:vietnam_beyond_the_horizon/screens/input_screen.dart';
import 'package:vietnam_beyond_the_horizon/widgets/intro_screen/template.dart';

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

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return IntroScreenTemplate(
      index: 0,
      total: 3,
      title: _FirstTitle(),
      content:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris efficitur ex sit amet elementum sagittis.',
      background: AssetImage("assets/backgrounds/introduce_first.png"),
      skipRoute: TransitionRLPageRoute(nextScreen: InputPage()),
      nextRoute: TransitionRLPageRoute(nextScreen: _SecondScreen()),
    );
  }
}

class _SecondScreen extends StatelessWidget {
  const _SecondScreen();
  @override
  Widget build(BuildContext context) {
    return IntroScreenTemplate(
      index: 1,
      total: 3,
      title: _SecondTitle(),
      content:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris efficitur ex sit amet elementum sagittis.',
      background: AssetImage("assets/backgrounds/introduce_second.png"),
      skipRoute: TransitionRLPageRoute(nextScreen: InputPage()),
      nextRoute: TransitionRLPageRoute(nextScreen: _ThirdScreen()),
    );
  }
}

class _ThirdScreen extends StatelessWidget {
  const _ThirdScreen();
  @override
  Widget build(BuildContext context) {
    return IntroScreenTemplate(
      index: 2,
      total: 3,
      title: _ThirdTitle(),
      content:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris efficitur ex sit amet elementum sagittis.',
      background: AssetImage("assets/backgrounds/introduce_third.png"),
      skipRoute: TransitionRLPageRoute(nextScreen: InputPage()),
      nextRoute: TransitionRLPageRoute(nextScreen: InputPage()),
    );
  }
}
