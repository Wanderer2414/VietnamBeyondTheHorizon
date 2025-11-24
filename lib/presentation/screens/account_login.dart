import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/login/decoration.dart'
    as login;
import 'package:vietnambeyondthehorizon/presentation/widgets/login/login_panel.dart'
    as login;

class AccountLoginScreen extends StatefulWidget {
  AccountLoginScreen({super.key});

  @override
  State<AccountLoginScreen> createState() => _AccountLoginScreenState();
}

class _AccountLoginScreenState extends State<AccountLoginScreen> {
  _Content? _content;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Size size = MediaQuery.of(context).size;
    _content = _Content(size);
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
            login.LoginPanel(size: screenSize),
          ],
        ),
      );
}
