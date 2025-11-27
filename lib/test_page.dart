import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/loading_screen.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  bool selected = true;

  void togglePanel() {
    setState(() {
      selected = !selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LoadingScreen());
  }
}
