import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/common/textbox_t2.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/profile_register/age_input.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/profile_register/city_input.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/profile_register/finish_button.dart';

class Panel extends StatelessWidget {
  final Size size;
  const Panel({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      alignment: Alignment.bottomCenter,
      child: Container(
        width: size.width,
        height: size.height * 0.7,
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
              width: size.width * 0.9,
              height: size.height * 0.19,
              padding: EdgeInsets.only(
                top: size.height * 0.05,
                bottom: size.height * 0.03,
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
              size: Size(size.width * 0.8, size.height * 0.06),
              hint: "Nguyen Van A",
            ),
            SizedBox(height: size.height * 0.03),
            AgeInput(size: Size(size.width, size.height * 0.06)),
            SizedBox(height: size.height * 0.03),
            CityInput(size: Size(size.width, size.height * 0.06)),
            SizedBox(height: size.height * 0.1),
            FinishButton(size: Size(size.width * 0.66, size.height * 0.05)),
          ],
        ),
      ),
    );
  }
}
