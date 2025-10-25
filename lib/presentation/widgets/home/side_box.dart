import 'package:flutter/material.dart';

class SideBox extends StatelessWidget {
  final Size size;
  const SideBox({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          padding: EdgeInsets.only(top: size.height * 0.07),
          margin: EdgeInsets.only(bottom: size.height * 0.05),
          decoration: BoxDecoration(shape: BoxShape.rectangle),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(side: BorderSide(width: 1.5)),
              fixedSize: Size.square(size.width * 0.7),
            ),
            child: null,
          ),
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Container(
            height: size.height * 0.03,
            alignment: Alignment.centerLeft,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Settings',
                style: TextStyle(fontFamily: "Inria Sans", fontSize: 20),
              ),
            ),
          ),
          onTap: () => Navigator.pop(context),
        ),
        ListTile(
          leading: Icon(Icons.info),
          title: Container(
            height: size.height * 0.03,
            alignment: Alignment.centerLeft,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'About us',
                style: TextStyle(fontFamily: "Inria Sans", fontSize: 20),
              ),
            ),
          ),
          onTap: () => Navigator.pop(context),
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Container(
            height: size.height * 0.03,
            alignment: Alignment.centerLeft,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Exit',
                style: TextStyle(fontFamily: "Inria Sans", fontSize: 20),
              ),
            ),
          ),
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
