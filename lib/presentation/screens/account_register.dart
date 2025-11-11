import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/login/decoration.dart'
    as login;
import 'package:vietnambeyondthehorizon/presentation/widgets/register/register_panel.dart'
    as register;

class AccountRegisterScreen extends StatefulWidget {
  const AccountRegisterScreen({super.key});

  @override
  State<AccountRegisterScreen> createState() => _AccountLoginScreenState();
}

class _AccountLoginScreenState extends State<AccountRegisterScreen> {
  late final _Content _content;
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
        child: Stack(
          children: [
            login.Decoration(),
            register.RegisterPanel(size: screenSize),
          ],
        ),
      );
}
