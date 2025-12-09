import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/data/user/user_account.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/map_controller.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/proxy/proxy.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/loading_screen.dart';
import 'package:vietnambeyondthehorizon/routes/main_route.dart';

class PlayConfirmBox extends StatelessWidget {
  final Size size;
  final UserAccount account;
  const PlayConfirmBox({super.key, required this.size, required this.account});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFD9),
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.all(13),
        child: Container(
          decoration: _ButtonDecoration(
            color: const Color(0xFFFFFFE8),
            radius: 20,
          ),
          child: Column(
            spacing: size.height * 0.05,
            children: [
              SizedBox(height: size.height * 0.07),
              SizedBox(
                width: size.width * 0.7,
                height: size.height * 0.3,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    children: const [
                      Text(
                        "DO YOU WANT TO START",
                        style: TextStyle(
                          fontFamily: "KronaOne",
                          fontSize: 30,
                          letterSpacing: 0,
                          wordSpacing: -5,
                        ),
                      ),
                      Text(
                        "THE JOURNEY?",
                        style: TextStyle(
                          fontFamily: "KronaOne",
                          fontSize: 50,
                          letterSpacing: 0,
                          wordSpacing: -5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: size.width * 0.7,
                height: size.height * 0.3,
                child: Row(
                  spacing: size.width * 0.1,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _Button(
                      size: size,
                      text: "Not yet",
                      color: const Color(0xFFFA6C6F),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    _Button(
                      size: size,
                      text: "Alright",
                      color: const Color(0xFF7CFF70),
                      onPressed: () {
                        MainRoute.pop();
                        LoadingManager.run(context, (context) async {
                          final route = await NetworkProxy.route;
                          final controller = MyMapController();
                          await controller.initialize();
                          if (route == null) {
                            MainRoute.goInputScreen(controller, account);
                          } else {
                            MainRoute.goGameScreen(controller, route, account);
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Button extends ElevatedButton {
  _Button({
    required Size size,
    required String text,
    required Color color,
    required Function()? onPressed,
  }) : super(
         onPressed: onPressed,
         style: _ButtonStyle(size: size),
         child: Container(
           width: size.width * 0.3,
           height: size.height * 0.25,
           decoration: _ButtonDecoration(color: color),
           alignment: Alignment.center,
           padding: EdgeInsets.all(10),
           child: FittedBox(
             child: Text(
               text,
               style: const TextStyle(
                 fontFamily: "KronaOne",
                 fontSize: 20,
                 color: Colors.black87,
               ),
             ),
           ),
         ),
       );
}

class _ButtonStyle extends ButtonStyle {
  _ButtonStyle({required Size size})
    : super(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
        ),
        fixedSize: WidgetStatePropertyAll(
          Size(size.width * 0.3, size.height * 0.3),
        ),
        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
        shadowColor: WidgetStatePropertyAll(Colors.transparent),
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        padding: WidgetStateProperty.resolveWith((Set<WidgetState> state) {
          if (state.contains(WidgetState.pressed)) {
            return EdgeInsets.only(
              top: size.height * 0.04,
              bottom: size.height * 0.01,
            );
          } else {
            return EdgeInsets.only(
              top: size.height * 0.02,
              bottom: size.height * 0.03,
            );
          }
        }),
      );
}

class _ButtonDecoration extends BoxDecoration {
  _ButtonDecoration({required Color color, double radius = 10})
    : super(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          const BoxShadow(
            color: Color(0x80000000),
            blurStyle: BlurStyle.inner,
            blurRadius: 5,
          ),
          BoxShadow(
            color: color,
            blurStyle: BlurStyle.inner,
            spreadRadius: 0,
            offset: Offset(1, 1),
            blurRadius: 10,
          ),
        ],
      );
}
