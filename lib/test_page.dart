import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/result_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/result/result_mission.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/result/result_point.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/result/result_summary.dart';

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
    return Scaffold(body: ResultAutoScreen());
  }
}
