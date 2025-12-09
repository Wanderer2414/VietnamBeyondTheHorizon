// import 'package:flutter/material.dart';
// import 'package:vietnambeyondthehorizon/presentation/widgets/intro_screen/background.dart';
// import 'package:vietnambeyondthehorizon/presentation/widgets/intro_screen/bottom_bar.dart';
// import 'package:vietnambeyondthehorizon/presentation/widgets/intro_screen/bottom_box.dart';
// import 'package:vietnambeyondthehorizon/presentation/widgets/intro_screen/bottom_content.dart';
// import 'package:vietnambeyondthehorizon/presentation/widgets/intro_screen/shader_filter.dart';

// class IntroScreenTemplate extends StatelessWidget {
//   final int index, total;
//   final Widget title;
//   final String content;
//   final ImageProvider background;
//   final Route skipRoute, nextRoute;
//   const IntroScreenTemplate({
//     super.key,
//     required this.index,
//     required this.total,
//     required this.title,
//     required this.content,
//     required this.background,
//     required this.skipRoute,
//     required this.nextRoute,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final Size screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//       body: Stack(
//         children: [
//           Background(screenSize: screenSize, background: background),
//           ShadowFilter(),
//           BottomBox(
//             screenSize: screenSize,
//             title: title,
//             content: content,
//             index: index,
//             total: total,
//             skipRoute: skipRoute,
//             nextRoute: nextRoute,
//           ),
//         ],
//       ),
//     );
//   }
// }
