import 'package:flutter/material.dart';

class TextboxT2 extends StatefulWidget {
  final Size size;
  final String hint;
  final Function()? onTap;
  final Function(String value)? onUpdate;

  const TextboxT2({
    super.key,
    required this.size,
    required this.hint,
    this.onTap,
    this.onUpdate,
  });

  @override
  State<TextboxT2> createState() => _TextboxT2State();
}

class _TextboxT2State extends State<TextboxT2> {
  TextEditingController _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size.width,
      height: widget.size.height,
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: widget.size.width,
          height: widget.size.height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: BoxBorder.all(width: 2, color: Colors.black38),
          ),
          padding: EdgeInsets.only(left: 10, right: 10),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              alignLabelWithHint: true,
              hint: Container(
                width: widget.size.width * 0.9,
                height: widget.size.height * 0.65,
                alignment: Alignment.bottomLeft,
                child: Text(
                  widget.hint,
                  style: TextStyle(color: Colors.black54, fontSize: 20),
                ),
              ),
            ),
            onTapOutside: (e) {
              FocusScope.of(context).unfocus();
              FocusScope.of(context).setFirstFocus(FocusScopeNode());
              if (widget.onUpdate != null) widget.onUpdate!(_controller.text);
            },
            onEditingComplete: () {
              if (widget.onUpdate != null) widget.onUpdate!(_controller.text);
            },
            onTap: widget.onTap,
          ),
        ),
      ),
    );
  }
}
