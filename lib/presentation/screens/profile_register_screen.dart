import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/login/decoration.dart'
    as login;
import 'package:vietnambeyondthehorizon/presentation/widgets/common/back_button.dart'
    as common;
import 'package:vietnambeyondthehorizon/presentation/widgets/profile_register/title.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/profile_register/panel.dart'
    as profilefill;

class ProfileRegister extends StatefulWidget {
  const ProfileRegister({super.key});

  @override
  State<ProfileRegister> createState() => _AccountLoginScreenState();
}

class _AccountLoginScreenState extends State<ProfileRegister> {
  late _Content _content; //Error: 'late final' throw Field aldready initialized
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Size screenSize = MediaQuery.of(context).size;
    _content = _Content(screenSize);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFFFDF9E),
      body: SingleChildScrollView(child: _content),
    );
  }
}

class _Content extends Container {
  _Content(Size screenSize)
    : super(
        width: screenSize.width,
        height: screenSize.height,
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(shape: BoxShape.rectangle),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            login.Decoration(),
            ProfileFillLabel(size: screenSize),
            common.BackButton(size: screenSize),
            profilefill.Panel(size: screenSize),
          ],
        ),
      );
}
