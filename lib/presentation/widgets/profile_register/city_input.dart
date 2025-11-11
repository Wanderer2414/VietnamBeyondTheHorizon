import 'package:flutter/material.dart';

class CityInput extends StatefulWidget {
  final Size size;
  const CityInput({super.key, required this.size});

  @override
  State<CityInput> createState() => _CityInputState();
}

class _CityInputState extends State<CityInput> {
  int? _cityCode;

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
          value: _cityCode,
          alignment: Alignment.centerRight,
          hint: Align(alignment: Alignment.center, child: Text("Select city")),
          isExpanded: true,
          items: [
            DropdownMenuItem<int>(
              value: 0,
              child: Align(
                alignment: Alignment.center,
                child: Text("Ho Chi Minh city"),
              ),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _cityCode = value;
            });
          },
        ),
      ),
    );
  }
}
