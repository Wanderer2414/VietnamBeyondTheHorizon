import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:vietnambeyondthehorizon/animations/screen/transition.dart';
import 'package:vietnambeyondthehorizon/data/models/game_progress.dart';
import 'package:vietnambeyondthehorizon/main.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/map_controller.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/loading_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/common/back_button.dart'
    as common;
import 'package:vietnambeyondthehorizon/routes/main_route.dart';

// Class lưu trữ thông tin đầu vào của user
class UserInput {
  static List<String> type = ['Attraction', 'Culture', 'Food', 'Entertainment'];
  int budget; // Tiền (VNĐ)
  int durationDays; // Duration (Ngày)
  int
  interests; // Interest (Yes/No cho attraction, food, culture, entertainment)

  UserInput({
    required this.budget,
    required this.durationDays,
    required this.interests,
  });

  List<LocationModel> getSelectedInterests(List<LocationModel?> interest) {
    return interest
        .where(
          (entry) =>
              (entry != null) &&
              (interests >> (type.indexOf(entry.type)) & 1 == 1),
        )
        .map((entry) => entry!)
        .toList();
  }
}

class InputPage extends StatefulWidget {
  final MyMapController controller;
  const InputPage({Key? key, required this.controller}) : super(key: key);

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> with RouteAware {
  _Content? _content;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);

    final screenSize = MediaQuery.of(context).size;
    final Size subSize = Size(screenSize.width * 0.8, screenSize.height * 0.08);
    if (_content == null)
      _content = _Content(
        screenSize: screenSize,
        subSize: subSize,
        controller: widget.controller,
      );
  }

  @override
  void didPopNext() {
    widget.controller.resetMap = () {};
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return LoadingWrapper(
      child: Scaffold(
        body: Container(
          width: screenSize.width,
          height: screenSize.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFF0E8), Color(0xFFB8F5F0), Color(0xFFFFF9C4)],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: common.BackButton(size: screenSize),
                ),

                // Main content
                _content!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Content extends StatefulWidget {
  const _Content({
    required this.screenSize,
    required this.subSize,
    required this.controller,
  });
  final MyMapController controller;
  final Size screenSize;
  final Size subSize;

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  int _budget = 20, _duration = 2, _opt = 15;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.screenSize.width * 0.9,
      height: widget.screenSize.height * 0.88,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/input_panel.png"),
          fit: BoxFit.fill,
        ),
      ),
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          // Plan Your Trip Button
          _LabelButton(screenSize: widget.screenSize),

          const SizedBox(height: 40),
          // Budget Field
          _InputField(
            label: 'Budget:',
            hint: '20\$',
            size: widget.subSize,
            unit: "\$",
            submitText: (value) => _budget = int.parse(value),
          ),

          SizedBox(height: widget.screenSize.height * 0.03),

          // Interest Field
          _InterestField(
            size: Size(
              widget.screenSize.width * 0.8,
              widget.screenSize.height * 0.2,
            ),
            onChange: (value) {
              _opt = value;
            },
            catogary: UserInput.type,
          ),
          SizedBox(height: widget.screenSize.height * 0.03),

          // Duration Field
          _InputField(
            label: 'Duration:',
            hint: '2 days',
            size: widget.subSize,
            unit: ' days',
            submitText: (value) => _duration = int.parse(value),
          ),
          // const SizedBox(height: 50),
          Spacer(),
          // Next Button
          _CreateButton(
            size: Size(
              widget.screenSize.width * 0.3,
              widget.screenSize.height * 0.05,
            ),
            onPressed: () {
              MainRoute.goSubmitRoute(
                widget.controller,
                UserInput(
                  budget: _budget,
                  durationDays: _duration,
                  interests: _opt,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LabelButton extends StatelessWidget {
  const _LabelButton({required this.screenSize});

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenSize.width * 0.36,
      height: screenSize.height * 0.06,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF8A5B), Color(0xFFFF6B6B)],
        ),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(10),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          'PLAN YOUR TRIP',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: "Kay Pho Du",
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatefulWidget {
  const _InputField({
    required this.label,
    required this.hint,
    required this.size,
    this.unit = "",
    required this.submitText,
  });
  final Function(String value) submitText;
  final String label;
  final String hint;
  final String unit;
  final Size size;

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              fontFamily: "Kay Pho Du",
            ),
          ),
          Spacer(),
          Container(
            width: widget.size.width * 0.65,
            height: widget.size.height * 0.9,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(25),
            ),
            alignment: Alignment.center,
            child: TextField(
              controller: _controller,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: widget.hint,
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onTapOutside: (_) {
                if (_controller.text == widget.unit)
                  _controller.text = '1' + _controller.text;
                FocusScope.of(context).unfocus();
                widget.submitText(_controller.text);
              },
              onEditingComplete: () {
                if (_controller.text == widget.unit)
                  _controller.text = '1' + _controller.text;
                FocusScope.of(context).unfocus();
                widget.submitText(_controller.text);
              },
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                TextInputFormatter.withFunction((oldValue, newValue) {
                  String text = newValue.text;
                  if (text.endsWith(widget.unit))
                    text = text.substring(0, text.length - widget.unit.length);
                  while (text.startsWith("0")) text = text.substring(1);

                  text += widget.unit;
                  return TextEditingValue(
                    text: text,
                    selection: TextSelection.collapsed(
                      offset: text.length - widget.unit.length,
                    ),
                  );
                }),
              ],
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateButton extends StatelessWidget {
  final Function() onPressed;
  const _CreateButton({required this.size, required this.onPressed});
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFFF59E0B), const Color(0xFFFF6B6B)],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          overlayColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: const Text(
          'NEXT',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            fontFamily: "Kay Pho Du",
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}

class _InterestField extends StatefulWidget {
  final Size size;
  final List<String> catogary;
  final Function(int value) onChange;
  const _InterestField({
    required this.size,
    required this.catogary,
    required this.onChange,
  });

  @override
  State<_InterestField> createState() => _InterestFieldState();
}

class _InterestFieldState extends State<_InterestField> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Interest:",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
            fontFamily: "Kay Pho Du",
          ),
        ),
        Spacer(),
        Container(
          width: widget.size.width * 0.65,
          height: widget.size.height,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            spacing: 0,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.catogary.length, (i) => i).map((i) {
              return Container(
                width: widget.size.width * 0.55,
                height: widget.size.height * 0.2,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _current ^= 1 << i;
                    });
                    widget.onChange(_current);
                  },
                  clipBehavior: Clip.hardEdge,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(5),
                    ),
                    alignment: Alignment.center,
                  ),
                  child: Row(
                    children: [
                      (_current >> i & 1 == 1)
                          ? Icon(
                              Icons.check_box,
                              color: Colors.orange,
                              size: widget.size.height * 0.15,
                            )
                          : Icon(
                              Icons.square_outlined,
                              color: Colors.black,
                              size: widget.size.height * 0.15,
                            ),
                      SizedBox(width: widget.size.width * 0.02),
                      Text(
                        widget.catogary[i],
                        style: TextStyle(
                          fontFamily: "Inria Sans",
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            // const Text(
            //   'Interest',
            //   style: TextStyle(
            //     fontSize: 15,
            //     fontWeight: FontWeight.w500,
            //     color: Colors.black87,
            //   ),
            // ),
            //   const SizedBox(height: 16),
            //   ...userInput.interests.entries.map((entry) {
            //     bool isOrange =
            //         entry.key == 'Culture' ||
            //         entry.key == 'Entertainment';
            //     return Padding(
            //       padding: const EdgeInsets.only(bottom: 12.0),
            //       child: InkWell(
            //         onTap: () {
            //           setState(() {
            //             userInput.interests[entry.key] =
            //                 !entry.value;
            //           });
            //         },
            //         child: Row(
            //           children: [
            //             Container(
            //               width: 26,
            //               height: 26,
            //               decoration: BoxDecoration(
            //                 color: entry.value
            //                     ? (isOrange
            //                           ? const Color(0xFFFF9800)
            //                           : Colors.black)
            //                     : Colors.white,
            //                 border: Border.all(
            //                   color: entry.value
            //                       ? (isOrange
            //                             ? const Color(0xFFFF9800)
            //                             : Colors.black)
            //                       : Colors.grey.shade400,
            //                   width: 2,
            //                 ),
            //                 borderRadius: BorderRadius.circular(6),
            //               ),
            //               child: entry.value
            //                   ? const Icon(
            //                       Icons.check,
            //                       size: 18,
            //                       color: Colors.white,
            //                     )
            //                   : null,
            //             ),
            //             const SizedBox(width: 14),
            //             Expanded(
            //               child: Text(
            //                 entry.key,
            //                 style: const TextStyle(
            //                   fontSize: 15,
            //                   fontWeight: FontWeight.w400,
            //                   color: Colors.black87,
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     );
            //   }).toList(),
          ),
        ),
      ],
    );
  }
}
