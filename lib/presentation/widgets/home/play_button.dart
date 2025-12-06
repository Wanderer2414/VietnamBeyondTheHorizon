import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/data/user/user_account.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/play_confirm_box.dart';

class PlayButton extends StatelessWidget {
  final double radius;
  final UserAccount account;
  const PlayButton({super.key, required this.radius, required this.account});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.black54,
          builder: (BuildContext context) {
            final Size size = MediaQuery.of(context).size;
            return PlayConfirmBox(
              size: Size(size.width * 0.8, size.height * 0.2),
              account: account,
            );
          },
        );
      },
      style: ButtonStyle(
        padding: WidgetStateProperty.resolveWith<EdgeInsets?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.pressed)) {
            return EdgeInsets.only(bottom: 3, top: 2);
          } else {
            return EdgeInsets.only(bottom: 5);
          }
        }),
        shape: WidgetStateProperty.all(CircleBorder()),
        fixedSize: WidgetStateProperty.all(Size(radius, radius)),
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        shadowColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.pressed)) {
            return Colors.transparent;
          } else {
            return Colors.black;
          }
        }),
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
      ),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              spreadRadius: 2,
              offset: Offset(0, 2),
              color: Color(0x32000000),
            ),
          ],
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage("assets/icons/gamepad.png"),
            ),
          ),
        ),
      ),
    );
  }
}
