import 'package:flutter/material.dart';

class RequestTask extends StatelessWidget {
  final Size size;
  final String content;
  final int reward;
  const RequestTask({
    super.key,
    required this.size,
    required this.content,
    required this.reward,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        padding: WidgetStateProperty.resolveWith<EdgeInsetsGeometry>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.pressed)) {
            return EdgeInsetsGeometry.only(top: 1, bottom: 1);
          } else {
            return EdgeInsetsGeometry.only(bottom: 2);
          }
        }),
        shadowColor: WidgetStatePropertyAll(Colors.transparent),
        fixedSize: WidgetStatePropertyAll(size),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
        ),
      ),
      onPressed: () {},
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFFF7B), Color(0xFFFF9500)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x79000000),
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: ListTile(
          leading: Icon(Icons.camera_alt, size: size.height / 2),
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              content,
              style: TextStyle(fontFamily: "Inder", fontSize: 17),
            ),
          ),
          trailing: Container(
            width: size.width * 0.22,
            height: size.height * 0.5,
            padding: EdgeInsets.only(left: size.width * 0.03),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              boxShadow: const [
                BoxShadow(color: Color(0xFFCBE2B0), blurStyle: BlurStyle.inner),
                BoxShadow(
                  color: Color(0x64000000),
                  blurRadius: 10,
                  blurStyle: BlurStyle.inner,
                ),
                BoxShadow(
                  color: Color(0xFFCBE2B0),
                  spreadRadius: -1,
                  blurRadius: 1,
                  offset: Offset(1, 1),
                  blurStyle: BlurStyle.inner,
                ),
              ],
            ),
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity(
                horizontal: -size.width * 0.01,
                vertical: -size.height * 0.06,
              ),
              horizontalTitleGap: -size.width * 0.05,
              minVerticalPadding: 0,
              leading: Container(
                width: size.height / 4,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/icons/diamond-icon.png"),
                  ),
                ),
              ),
              title: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  " x $reward",
                  style: TextStyle(fontFamily: "Inder", fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
