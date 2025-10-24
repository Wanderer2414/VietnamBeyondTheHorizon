import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InformationRegisterStation extends StatelessWidget {
  const InformationRegisterStation({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: InformationRegisterScreen());
  }
}

class InformationRegisterScreen extends StatefulWidget {
  const InformationRegisterScreen({super.key});
  @override
  State<StatefulWidget> createState() => InfomationRegisterScreenState();
}

class InfomationRegisterScreenState extends State<InformationRegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(0xFF, 0xFF, 0xDF, 0x9E),
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
      decoration: BoxDecoration(shape: BoxShape.rectangle),
      clipBehavior: Clip.hardEdge,
      width: size.width,
      height: size.height,
      child: FittedBox(
        alignment: Alignment.centerLeft,
        fit: BoxFit.scaleDown,
        child: Text(
          "Create your\nprofile",
          style: TextStyle(
            color: Color.fromARGB(0xFF, 0x79, 0x51, 00),
            fontFamily: "InriaSans",
            fontWeight: FontWeight.w500,
            fontSize: size.height * 0.3,
          ),
        ),
      ),
    );
  }
}

class InputPanel extends StatelessWidget {
  final Size size;
  const InputPanel({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        shape: BoxShape.rectangle,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.3),
            offset: Offset(2, 1),
            blurRadius: 2,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(-2, 1),
            blurRadius: 2,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: size.height * 0.1),
          InputNameBox(size: Size(size.width * 0.9, size.height * 0.1)),
          SizedBox(height: size.height * 0.03),
          InputAgeBox(size: Size(size.width * 0.9, size.height * 0.1)),
          SizedBox(height: size.height * 0.03),
          InputCity(size: Size(size.width * 0.9, size.height * 0.1)),
        ],
      ),
    );
  }
}

class InputNameBox extends StatefulWidget {
  final Size size;

  const InputNameBox({super.key, required this.size});

  @override
  State<InputNameBox> createState() => _InputNameBoxState();
}

class _InputNameBoxState extends State<InputNameBox> {
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
            "Name:",
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
            maxLines: 1,
            style: TextStyle(
              fontFamily: "InriaSans",
              color: Colors.black,
              fontSize: widget.size.height * 0.4,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Color.fromARGB(255, 0xF2, 0xF2, 0xF2),
              filled: true,
              hintText: "Enter your name",
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9 ]")),
            ],
            textAlign: TextAlign.center,
            onChanged: (value) => setState(() {
              name = value;
            }),
          ),
        ),
        SizedBox(width: widget.size.width * 0.05),
      ],
    );
  }
}

class InputAgeBox extends StatefulWidget {
  final Size size;
  const InputAgeBox({super.key, required this.size});

  @override
  State<InputAgeBox> createState() => _InputAgeBoxState();
}

class _InputAgeBoxState extends State<InputAgeBox> {
  int? _selectedAge;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.only(left: widget.size.width * 0.1),
          child: Text(
            "Age:",
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
            color: Color.fromARGB(255, 0xF2, 0xF2, 0xF2),
          ),
          clipBehavior: Clip.antiAlias,
          child: DropdownButton<int>(
            value: _selectedAge,
            alignment: Alignment.centerRight,
            menuMaxHeight: widget.size.height * 10,
            style: TextStyle(
              fontFamily: "InriaSans",
              fontSize: widget.size.height * 0.4,
              overflow: TextOverflow.clip,
              color: Colors.black,
            ),
            hint: Align(alignment: Alignment.center, child: Text("Select age")),
            isExpanded: true,
            items: List.generate(81, (index) => index + 10).map((int age) {
              return DropdownMenuItem<int>(
                value: age,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(age.toString()),
                ),
              );
            }).toList(),
            onChanged: (value) {
              _selectedAge = value;
            },
          ),
        ),
        SizedBox(width: widget.size.width * 0.05),
      ],
    );
  }
}

class InputCity extends StatefulWidget {
  final Size size;
  const InputCity({super.key, required this.size});

  @override
  State<InputCity> createState() => _InputCityState();
}

class _InputCityState extends State<InputCity> {
  String? _selectedCity;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.only(left: widget.size.width * 0.1),
          child: Text(
            "City:",
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
            color: Color.fromARGB(255, 0xF2, 0xF2, 0xF2),
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: DropdownButton<String>(
            value: _selectedCity,
            alignment: Alignment.centerRight,
            hint: Align(
              alignment: Alignment.center,
              child: Text("Your interest city"),
            ),
            style: TextStyle(
              fontFamily: "InriaSans",
              fontSize: widget.size.height * 0.4,
              color: Colors.black,
              overflow: TextOverflow.clip,
            ),
            isExpanded: true,
            items: [
              DropdownMenuItem(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("Ho Chi Minh city"),
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedCity = value;
              });
            },
          ),
        ),
        SizedBox(width: widget.size.width * 0.05),
      ],
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
        backgroundColor: Color.fromARGB(0xFF, 0xD9, 0x91, 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
        fixedSize: widget.size,
      ),
      child: FittedBox(
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
