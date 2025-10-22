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
  int? _selectedAge;
  String? _selectedCity, _inputName;
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(0xFF, 0xFF, 0xDF, 0x9E),
      body: Column(
        children: [
          //Title
          Padding(
            padding: EdgeInsetsGeometry.only(
              top: screenSize.height * 0.05,
              left: screenSize.width / 103 * 8,
            ),
            child: Text(
              "Create your profile",
              style: TextStyle(
                color: Color.fromARGB(0xFF, 0x79, 0x51, 00),
                fontFamily: "InriaSans",
                fontWeight: FontWeight.w500,
                fontSize: 40,
              ),
            ),
          ),
          Spacer(),
          //Input box
          Container(
            width: screenSize.width / 412 * 372,
            height: screenSize.height / 917.0 * 654,
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
                SizedBox(height: screenSize.height * 0.1),
                //First input row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsetsGeometry.only(
                        left: screenSize.width * 0.06,
                      ),
                      child: Text(
                        "Name:",
                        style: TextStyle(fontFamily: "InriaSans", fontSize: 16),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: screenSize.width * 0.7,
                      padding: EdgeInsets.only(right: screenSize.width * 0.05),
                      alignment: Alignment.topRight,
                      child: Container(
                        width: screenSize.width * 0.6,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: TextField(
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: "InriaSans",
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Color.fromARGB(255, 0xF2, 0xF2, 0xF2),
                            filled: true,
                            hintText: "Enter your name",
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp("[a-zA-Z0-9 ]"),
                            ),
                          ],
                          textAlign: TextAlign.center,
                          onChanged: (value) => setState(() {
                            _inputName = value;
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenSize.height * 0.02),
                //Second input row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsetsGeometry.only(
                        left: screenSize.width * 0.06,
                      ),
                      child: Text(
                        "Age:",
                        style: TextStyle(fontFamily: "InriaSans", fontSize: 16),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: screenSize.width * 0.7,
                      padding: EdgeInsets.only(right: screenSize.width * 0.05),
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: screenSize.width * 0.6,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: DropdownButton<int>(
                          value: _selectedAge,
                          alignment: Alignment.centerRight,
                          hint: Align(
                            alignment: Alignment.center,
                            child: Text("Select age"),
                          ),
                          isExpanded: true,
                          items: List.generate(81, (index) => index + 81).map((
                            int age,
                          ) {
                            return DropdownMenuItem<int>(
                              value: age,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(age.toString()),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedAge = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenSize.height * 0.02),
                //Third input row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsetsGeometry.only(
                        left: screenSize.width * 0.06,
                      ),
                      child: Text(
                        "City:",
                        style: TextStyle(fontFamily: "InriaSans", fontSize: 16),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: screenSize.width * 0.7,
                      padding: EdgeInsets.only(right: screenSize.width * 0.05),
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: screenSize.width * 0.6,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
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
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    Spacer(),
                    Padding(
                      padding: EdgeInsetsGeometry.only(
                        right: screenSize.width * 0.02,
                        bottom: screenSize.height * 0.03,
                      ),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(0xFF, 0xD9, 0x91, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                        ),
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
