import 'package:flutter/material.dart';

class AgeInput extends StatefulWidget {
  final Size size;
  final Function(int?)? onChanged;
  const AgeInput({super.key, required this.onChanged, required this.size});

  @override
  State<AgeInput> createState() => _AgeInputState();
}

class _AgeInputState extends State<AgeInput> {
  int? _selectedAge;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size.width * 0.8,
      alignment: Alignment.centerRight,
      child: Container(
        width: widget.size.width,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(width: 1, color: Colors.black54),
        ),
        clipBehavior: Clip.antiAlias,
        child: DropdownButton<int>(
          value: _selectedAge,
          alignment: Alignment.centerRight,
          hint: Align(alignment: Alignment.center, child: Text("Select age")),
          isExpanded: true,
          items: List.generate(81, (index) => index + 5).map((int age) {
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
            widget.onChanged?.call(value);
          },
        ),
      ),
    );
  }
}
