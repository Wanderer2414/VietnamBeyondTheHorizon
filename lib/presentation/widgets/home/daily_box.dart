import 'package:flutter/cupertino.dart';
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
