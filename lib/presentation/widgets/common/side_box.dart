import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/auth_controller.dart';

class SideBox extends ConsumerStatefulWidget {
  const SideBox({super.key});

  @override
  ConsumerState<SideBox> createState() => _SideBoxState();
}

class _SideBoxState extends ConsumerState<SideBox> {
  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authProvider);
    final Size size = MediaQuery.of(context).size;
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
              fixedSize: Size.square(size.width * 0.3),
            ),
            child: null,
          ),
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Container(
            height: size.height * 0.03,
            alignment: Alignment.centerLeft,
            child: const FittedBox(
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
            child: const FittedBox(
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
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Exit',
                style: TextStyle(fontFamily: "Inria Sans", fontSize: 20),
              ),
            ),
          ),
          onTap: () {
            auth.logout();
            // Navigator.of(
            //   context,
            // ).pushNamedAndRemoveUntil("log_navigator", (route) => false);
          },
        ),
      ],
    );
  }
}
