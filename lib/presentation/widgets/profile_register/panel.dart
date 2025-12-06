import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/common/textbox_t2.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/profile_register/age_input.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/profile_register/city_input.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/profile_register/finish_button.dart';

class Panel extends StatefulWidget {
  final Size size;

  const Panel({super.key, required this.size});

  @override
  State<Panel> createState() => _PanelState();
}

class _PanelState extends State<Panel> {
  int? age;
  int? cityCode;
  String _name = "";

  @override
  void initState() {
    super.initState();
    age = 17;
    cityCode = 0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size.height,
      alignment: Alignment.bottomCenter,
      child: Container(
        width: widget.size.width,
        height: widget.size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: widget.size.width * 0.9,
              height: widget.size.height * 0.19,
              padding: EdgeInsets.only(
                top: widget.size.height * 0.05,
                bottom: widget.size.height * 0.03,
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 2),
                ),
                child: null,
              ),
            ),
            TextboxT2(
              onUpdate: (value) => _name = value,
              size: Size(widget.size.width * 0.8, widget.size.height * 0.06),
              hint: "Nguyen Van A",
            ),
            SizedBox(height: widget.size.height * 0.03),
            AgeInput(
              size: Size(widget.size.width, widget.size.height * 0.06),
              onChanged: (value) {
                setState(() {
                  age = value;
                });
              },
            ),
            SizedBox(height: widget.size.height * 0.03),
            CityInput(
              size: Size(widget.size.width, widget.size.height * 0.06),
              onChanged: (value) {
                setState(() {
                  cityCode = value;
                });
              },
            ),
            SizedBox(height: widget.size.height * 0.1),
            FinishButton(
              size: Size(widget.size.width * 0.66, widget.size.height * 0.05),
              age: age,
              cityCode: cityCode,
              name: _name,
            ),
          ],
        ),
      ),
    );
  }
}
