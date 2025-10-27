import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final passwordProvider = StateProvider<String>((ref) => "");

class InformationRegisterStation extends StatelessWidget {
  const InformationRegisterStation({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: AccountRegisterScreen());
  }
}

class AccountRegisterScreen extends StatefulWidget {
  const AccountRegisterScreen({super.key});
  @override
  State<StatefulWidget> createState() => AccountRegisterScreenState();
}

class AccountRegisterScreenState extends State<AccountRegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFFFDF9E),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsGeometry.only(
                left: screenSize.width * 0.1,
                top: screenSize.height * 0.1,
              ),
              child: Title(
                size: Size(screenSize.width, screenSize.height * 0.15),
              ),
            ),
            SizedBox(height: screenSize.height * 0.1),
            Center(
              child: InputPanel(
                size: Size(screenSize.width * 0.9, screenSize.height * 0.65),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: EdgeInsetsGeometry.only(right: screenSize.width * 0.05),
        child: NextButton(
          size: Size(screenSize.width * 0.22, screenSize.height * 0.05),
        ),
      ),
    );
  }
}

class Title extends StatelessWidget {
  final Size size;
  const Title({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(shape: BoxShape.rectangle),
      clipBehavior: Clip.hardEdge,
      width: size.width,
      height: size.height,
      child: FittedBox(
        alignment: Alignment.centerLeft,
        fit: BoxFit.scaleDown,
        child: Text(
          "Register",
          style: TextStyle(
            color: const Color(0xFF795100),
            fontFamily: "InriaSans",
            fontWeight: FontWeight.w500,
            fontSize: size.height * 0.3,
          ),
        ),
      ),
    );
  }
}

class InputPanel extends StatefulWidget {
  final Size size;

  InputPanel({super.key, required this.size});
  @override
  State<InputPanel> createState() => _InputPanelState();
}

class _InputPanelState extends State<InputPanel> {
  final List<FocusNode> nodes = List<FocusNode>.generate(
    3,
    (int val) => FocusNode(),
  );

  @override
  void dispose() {
    super.dispose();
    for (int i = 0; i < 3; i++) {
      nodes[i].dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size.width,
      height: widget.size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        shape: BoxShape.rectangle,
        boxShadow: [
          const BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.3),
            offset: Offset(2, 1),
            blurRadius: 2,
            spreadRadius: 1,
          ),
          const BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(-2, 1),
            blurRadius: 2,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: widget.size.height * 0.1),
          EmailBox(
            size: Size(widget.size.width * 0.9, widget.size.height * 0.08),
            self: nodes[0],
            next: nodes[1],
          ),
          SizedBox(height: widget.size.height * 0.03),
          PasswordBox(
            size: Size(widget.size.width * 0.9, widget.size.height * 0.08),
            self: nodes[1],
            next: nodes[2],
          ),
          SizedBox(height: widget.size.height * 0.03),
          PasswordConfirmBox(
            size: Size(widget.size.width * 0.9, widget.size.height * 0.08),
            self: nodes[2],
            next: nodes[2],
          ),
        ],
      ),
    );
  }
}

class EmailBox extends StatefulWidget {
  final Size size;
  final FocusNode next, self;
  const EmailBox({
    super.key,
    required this.size,
    required this.next,
    required this.self,
  });

  @override
  State<EmailBox> createState() => _EmailBoxState();
}

class _EmailBoxState extends State<EmailBox> {
  String? name;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.only(left: widget.size.width * 0.1),
          child: Text(
            "Email:",
            style: TextStyle(
              fontFamily: "InriaSans",
              fontSize: widget.size.height * 0.4,
            ),
          ),
        ),
        Spacer(),
        Container(
          width: widget.size.width * 0.6,
          height: widget.size.height,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15),
          ),
          clipBehavior: Clip.antiAlias,
          child: TextField(
            focusNode: widget.self,
            maxLines: 1,
            style: TextStyle(
              fontFamily: "InriaSans",
              color: Colors.black,
              fontSize: widget.size.height * 0.4,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              fillColor: Color(0xFFF2F2F2),
              filled: true,
              hintText: "Enter your email",
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9@.]")),
            ],
            textAlign: TextAlign.center,
            onChanged: (value) => setState(() {
              name = value;
            }),
            textInputAction: TextInputAction.done,
            showCursor: widget.self.hasFocus,
            onSubmitted: (value) => setState(() {
              FocusScope.of(context).requestFocus(widget.next);
            }),
          ),
        ),
        SizedBox(width: widget.size.width * 0.05),
      ],
    );
  }
}

class PasswordBox extends ConsumerWidget {
  final Size size;
  final FocusNode self, next;
  const PasswordBox({
    super.key,
    required this.size,
    required this.self,
    required this.next,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.only(left: size.width * 0.1),
          child: Text(
            "Password:",
            style: TextStyle(
              fontFamily: "InriaSans",
              fontSize: size.height * 0.4,
            ),
          ),
        ),
        Spacer(),
        Container(
          width: size.width * 0.6,
          height: size.height,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15),
          ),
          clipBehavior: Clip.antiAlias,
          child: TextField(
            focusNode: self,
            showCursor: self.hasFocus,
            maxLines: 1,
            style: TextStyle(
              fontFamily: "InriaSans",
              color: Colors.black,
              fontSize: size.height * 0.4,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              fillColor: Color(0xFFF2F2F2),
              filled: true,
              hintText: "Enter your password",
            ),
            obscureText: true,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9@.]")),
            ],
            textAlign: TextAlign.center,
            onChanged: (value) {
              ref.read(passwordProvider.notifier).state = value;
            },
            textInputAction: TextInputAction.next,
            onSubmitted: (value) {
              FocusScope.of(context).requestFocus(next);
            },
          ),
        ),
        SizedBox(width: size.width * 0.05),
      ],
    );
  }
}

class PasswordConfirmBox extends StatefulWidget {
  final Size size;
  final FocusNode self, next;
  const PasswordConfirmBox({
    super.key,
    required this.size,
    required this.self,
    required this.next,
  });

  @override
  State<PasswordConfirmBox> createState() => _PasswordConfirmBoxState();
}

class _PasswordConfirmBoxState extends State<PasswordConfirmBox> {
  String? text;

  _PasswordConfirmBoxState();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final String text = ref.watch(passwordProvider);
        Color boundedColor = Colors.red;
        if (this.text == text && text != "") boundedColor = Colors.green;
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsetsGeometry.only(left: widget.size.width * 0.1),
              child: Text(
                "Confirm",
                style: TextStyle(
                  fontFamily: "InriaSans",
                  fontSize: widget.size.height * 0.4,
                ),
              ),
            ),
            Spacer(),
            Container(
              width: widget.size.width * 0.6,
              height: widget.size.height,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15),
                // color: Colors.transparent,
                boxShadow: [BoxShadow(color: boundedColor, blurRadius: 2)],
              ),
              clipBehavior: Clip.antiAlias,
              child: TextField(
                style: TextStyle(
                  fontFamily: "InriaSans",
                  color: Colors.black,
                  fontSize: widget.size.height * 0.4,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xFFF2F2F2),
                  filled: true,
                  hintText: "Confirm your password",
                ),
                obscureText: true,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9@.]")),
                ],
                textAlign: TextAlign.center,
                onChanged: (value) {
                  setState(() {
                    this.text = value;
                  });
                },
                focusNode: widget.self,
                showCursor: widget.self.hasFocus,
                textInputAction: TextInputAction.done,
                onSubmitted: (value) {
                  FocusScope.of(context).unfocus();
                },
              ),
            ),
            SizedBox(width: widget.size.width * 0.05),
          ],
        );
      },
    );
  }
}

class NextButton extends StatefulWidget {
  final Size size;
  const NextButton({super.key, required this.size});

  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD99100),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
        fixedSize: widget.size,
      ),
      child: const FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          "NEXT",
          style: TextStyle(
            fontFamily: "Jost",
            fontWeight: FontWeight.w300,
            fontSize: 19,
            color: Colors.white,
          ),
          softWrap: false,
        ),
      ),
    );
  }
}
