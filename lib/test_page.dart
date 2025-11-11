import 'package:flutter/material.dart';

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
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(color: Colors.grey[200]),

          //MissionCard(location: location, onNavigatingToLocationInfo: onNavigatingToLocationInfo, controller: controller)
          // Location info
          // AnimatedPositioned(
          //   duration: const Duration(milliseconds: 600),
          //   curve: Curves.fastEaseInToSlowEaseOut,
          //   top: selected ? screenSize.height * 0.5 : screenSize.height,
          //   left: 0,
          //   right: 0,
          //   child: SizedBox(
          //     height: screenSize.height * 0.5,
          //     child: SingleChildScrollView(
          //       child: LocationInfoWidget(onClose: togglePanel),
          //     ),
          //   ),
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: togglePanel,
        child: Icon(Icons.swap_vert),
      ),
    );
  }
}
