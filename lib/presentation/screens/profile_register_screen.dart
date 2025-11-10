import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/login/decoration.dart'
    as login;
import 'package:vietnambeyondthehorizon/presentation/widgets/login/back_button.dart'
    as login;
import 'package:vietnambeyondthehorizon/presentation/widgets/profile_register/title.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/profile_register/panel.dart'
    as profilefill;

class ProfileRegister extends StatefulWidget {
  const ProfileRegister({super.key});

  @override
  State<ProfileRegister> createState() => _AccountLoginScreenState();
}

class _AccountLoginScreenState extends State<ProfileRegister> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFFFDF9E),
      body: SingleChildScrollView(
        child: Container(
          width: screenSize.width,
          height: screenSize.height,
          alignment: Alignment.bottomCenter,
          child: Stack(
            children: [
              login.Decoration(),
              ProfileFillLabel(size: screenSize),
              login.BackButton(size: screenSize),
              profilefill.Panel(size: screenSize),
            ],
          ),
        ),
      ),
    );
  }
}
