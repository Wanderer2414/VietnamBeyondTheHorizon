import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/request_task.dart'
    as home_widgets;

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
          const BoxShadow(
            offset: Offset(0, 0),
            blurStyle: BlurStyle.outer,
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x78000000),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: size.height * 0.1),
            width: size.width * 0.9,
            height: size.height * 0.4,
            alignment: Alignment.centerLeft,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: const Text(
                "Daily Quest",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Inder",
                  fontSize: 31,
                ),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.05),
          Center(
            child: home_widgets.RequestTask(
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
