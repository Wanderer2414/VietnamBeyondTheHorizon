import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/gems_box.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/stars_box.dart';

class HomeAppbar extends AppBar {
  HomeAppbar({
    super.key,
    required GlobalKey<ScaffoldState> superKey,
    required Size size,
  }) : super(
         backgroundColor: Color(0xFFFF9500),
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadiusGeometry.only(
             bottomLeft: Radius.circular(20),
             bottomRight: Radius.circular(20),
           ),
         ),
         toolbarHeight: size.height * 0.8,
         leading: ElevatedButton(
           style: ElevatedButton.styleFrom(
             backgroundColor: Colors.transparent,
             shadowColor: Colors.transparent,
             padding: EdgeInsets.only(
               bottom: size.height * 0.2,
               left: size.height * 0.2,
             ),
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadiusGeometry.circular(10),
             ),
           ),
           onPressed: () {
             superKey.currentState?.openDrawer();
           },
           child: Container(
             width: size.height * 0.8,
             height: size.height * 0.8,
             decoration: BoxDecoration(
               image: DecorationImage(
                 image: AssetImage("assets/icons/bar.png"),
               ),
             ),
           ),
         ),
         actionsPadding: EdgeInsets.only(
           right: size.width * 0.1,
           bottom: size.height * 0.25,
         ),
         actions: [
           Row(
             spacing: size.width * 0.08,
             children: [
               GemsBox(size: Size(size.width * 0.15, size.height * 0.45)),

               StarsBox(size: Size(size.width * 0.15, size.height * 0.45)),
             ],
           ),
         ],
       );
}
