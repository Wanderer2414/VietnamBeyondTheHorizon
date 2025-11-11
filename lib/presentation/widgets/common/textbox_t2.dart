import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextboxT2 extends ConsumerWidget {
  final Size size;
  final String hint;
  final Function()? onTap;
  final StateProvider<String> provider;
  const TextboxT2({
    super.key,
    required this.size,
    required this.hint,
    required this.provider,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: size.width,
      height: size.height,
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: BoxBorder.all(width: 2, color: Colors.black38),
          ),
          padding: EdgeInsets.only(left: 10, right: 10),
          child: TextField(
            decoration: InputDecoration(
              focusColor: Colors.black,
              border: InputBorder.none,
              alignLabelWithHint: true,
              hint: Container(
                width: size.width * 0.9,
                height: size.height * 0.65,
                alignment: Alignment.bottomLeft,
                child: Text(
                  hint,
                  style: TextStyle(color: Colors.black54, fontSize: 20),
                ),
              ),
            ),
            onTapOutside: (e) {
              FocusScope.of(context).unfocus();
              FocusScope.of(context).setFirstFocus(FocusScopeNode());
            },
            onChanged: (value) {
              ref.read(provider.notifier).state = value;
            },
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
