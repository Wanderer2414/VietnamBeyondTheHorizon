import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vietnambeyondthehorizon/data/models/game_progress.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:vietnambeyondthehorizon/data/models/mission_model.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/map_controller.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/proxy/proxy.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/submit_route_map/map_show.dart';

class Content extends StatefulWidget {
  final GameRoute route;
  final void Function(LocationModel location) onLocationPress;
  final void Function(GameRoute route) onStart;
  const Content({
    super.key,
    required this.controller,
    required this.screenSize,
    required this.route,
    required this.onLocationPress,
    required this.onStart,
  });

  final MyMapController controller;
  final Size screenSize;

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  void Function(MissionModel model)? func;
  LocationModel? chosenLocation;
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    var mapShow = MapShow(
      controller: widget.controller,
      size: Size(screenSize.width, screenSize.height * 0.6),
    );
    return Stack(
      children: [
        mapShow,
        Positioned(
          left: 10,
          bottom: screenSize.height * 0.4 + 10,
          child: IconButton(
            onPressed: () => widget.controller.moveToCurrentLocation(),
            style: IconButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(10),
              ),
              fixedSize: Size.square(55),
            ),
            icon: Icon(Icons.my_location, color: Colors.white, size: 30),
          ),
        ),
        Positioned(
          right: 0,
          bottom: screenSize.height * 0.4 + 10,
          child: Container(
            width: screenSize.width * 0.35,
            height: 55,
            child: Stack(
              children: [
                Positioned(
                  left: 10,
                  child: CustomPaint(
                    painter: _Decoration(),
                    size: Size(screenSize.width * 0.27, 55),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 5,
                  child: Transform.rotate(
                    child: Icon(Icons.sports_score, size: 40),
                    angle: pi / 10,
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 5,
                  child: Icon(Icons.directions_run, size: 40),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Start",
                    style: TextStyle(
                      fontFamily: "Kay Pho Du",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => widget.onStart(widget.route),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(screenSize.width * 0.37, 55),
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    overlayColor: Colors.transparent,
                  ),
                  child: null,
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: screenSize.width,
            height: screenSize.height * 0.4,
            decoration: BoxDecoration(color: Colors.white),
            child: _SubmitPanel(
              missions: widget.route.missions,
              onLocationPress: widget.onLocationPress,
              screenSize: screenSize,
              chooseOneMission: (func) {
                widget.controller.toggleLocation = (location) {
                  this.chosenLocation = location;
                  setState(() {});
                };
                setState(() {
                  this.func = func;
                });
              },
            ),
          ),
        ),
        if (func != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: screenSize.width,
              height: screenSize.height * 0.4,
              color: Colors.black54,
              alignment: Alignment.center,
              child: Container(
                width: widget.screenSize.width,
                height: widget.screenSize.height * 0.4,
                color: Colors.black54,
                alignment: Alignment.center,
                child: Container(
                  width: widget.screenSize.width * 0.6,
                  child: Text(
                    "Choose one location...",
                    style: TextStyle(
                      fontFamily: "Kay Pho Du",
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (func != null)
          Positioned(
            top: 10,
            right: 10,
            child: TextButton(
              onPressed: () {
                if (this.chosenLocation != null) {
                  NetworkProxy.quest.then((value) {
                    final mission =
                        value!.missions[this.chosenLocation!.missionID[Random()
                            .nextInt(this.chosenLocation!.missionID.length)]];
                    func?.call(mission!);
                    func = null;
                    widget.controller.toggleLocation = null;
                    this.chosenLocation = null;
                    setState(() {});
                  });
                }
              },
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(5),
                ),
                fixedSize: Size(
                  screenSize.width * 0.3,
                  screenSize.height * 0.05,
                ),
                backgroundColor: (chosenLocation != null)
                    ? Colors.greenAccent
                    : Colors.grey,
              ),
              child: Row(
                children: [
                  Text(
                    "Submit ",
                    style: TextStyle(
                      fontFamily: "Kay Pho Du",
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  Icon(Icons.check_circle, color: Colors.white),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _Decoration extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill
      ..strokeWidth = 4;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.2, size.height * 0.5)
      ..lineTo(0, size.height)
      ..lineTo(size.width * 0.8, size.height)
      ..lineTo(size.width, size.height * 0.5)
      ..lineTo(size.width * 0.8, 0)
      ..lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _SubmitPanel extends StatefulWidget {
  _SubmitPanel({
    required this.missions,
    required this.onLocationPress,
    required this.screenSize,
    required this.chooseOneMission,
  });

  final List<MissionModel> missions;
  final Size screenSize;
  final Function(LocationModel loc) onLocationPress;
  final Function(void Function(MissionModel model)) chooseOneMission;

  @override
  State<_SubmitPanel> createState() => _SubmitPanelState();
}

class _SubmitPanelState extends State<_SubmitPanel> {
  final List<_BoxController> controllers = [];
  Timer? _timer;
  double _scroll = 0, _scrollAccelerator = 0;
  bool _isChoosing = false;
  @override
  void initState() {
    super.initState();
    controllers.addAll(
      List.generate(widget.missions.length, (e) => _BoxController()),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    double min_offset =
        widget.screenSize.height * 0.1 * (4 - widget.missions.length);
    _scroll += _scrollAccelerator * 2;
    if (_scroll < min_offset) {
      _scroll = min_offset;
      _scrollAccelerator = 0;
      _timer?.cancel();
    }
    if (_scroll > 0) {
      _scroll = 0;
      _scrollAccelerator = 0;
      _timer?.cancel();
    }

    if (_scrollAccelerator.abs() > 0.5) {
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
        if (_scrollAccelerator < -2)
          _scrollAccelerator += 1;
        else if (_scrollAccelerator > 2)
          _scrollAccelerator -= 1;
        else {
          _scrollAccelerator = 0;
          _timer?.cancel();
        }
        setState(() {});
      });
    } else {
      _scrollAccelerator = 0;
      _timer?.cancel();
    }
  }

  int? _oldIndex;

  void resetState() {
    if (_oldIndex != null) {
      controllers[_oldIndex!].resetColor?.call();
      controllers[_oldIndex!].onDrag?.call(-20);
      _oldIndex = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = Size(
      widget.screenSize.width,
      widget.screenSize.height * widget.missions.length * 0.1,
    );
    return Draggable(
      feedback: Container(),
      onDragUpdate: (details) {
        if (_isChoosing) return;
        if (details.delta.dx.abs() > 5) {
          double index =
              (details.localPosition.dy - _scroll) /
              (widget.screenSize.height * 0.1);
          index = index - 6;
          resetState();

          _oldIndex = index.floor();
          controllers[_oldIndex!].onDrag?.call(details.delta.dx);
        } else {
          _scrollAccelerator = details.delta.dy;
          setState(() {});
        }
      },
      child: Container(
        width: size.width,
        height: size.height,
        child: Stack(
          children: List.generate(widget.missions.length, (index) => index)
              .map<Widget>((i) {
                return Positioned(
                  top: widget.screenSize.height * 0.1 * i + _scroll,
                  child: _LocationSelection(
                    controller: controllers[i],
                    size: Size(
                      widget.screenSize.width,
                      widget.screenSize.height * 0.1,
                    ),
                    onTab: (location) => widget.onLocationPress(location),
                    onLocationPress: widget.onLocationPress,
                    onAddBelow: (index) => widget.chooseOneMission((model) {
                      this._isChoosing = false;
                      final i = index + 1;
                      widget.missions.insert(i, model);
                      controllers.add(_BoxController());
                      setState(() {});
                    }),
                    location: widget.missions[i].location!,
                    index: i,
                    onRemove: (index) {
                      widget.missions.removeAt(index);
                      controllers.removeAt(index);
                      resetState();
                      setState(() {});
                    },
                  ),
                );
              })
              .toList(),
        ),
      ),
    );
  }
}

class _BoxController {
  void Function(double dx)? onDrag;
  void Function(Color color)? setColor;
  void Function()? resetColor;
}

class _LocationSelection extends StatefulWidget {
  const _LocationSelection({
    required this.size,
    required this.onLocationPress,
    required this.location,
    required this.index,
    required this.controller,
    required this.onTab,
    required this.onRemove,
    required this.onAddBelow,
  });

  final _BoxController controller;
  final int index;
  final Size size;
  final LocationModel location;
  final Function(int index) onRemove;
  final Function(int index) onAddBelow;
  final Function(LocationModel loc) onLocationPress;
  final Function(LocationModel) onTab;

  @override
  State<_LocationSelection> createState() => _LocationSelectionState();
}

class _LocationSelectionState extends State<_LocationSelection> {
  double offset = 0;
  Timer? timer;
  Color color = Colors.transparent;

  @override
  void initState() {
    super.initState();
    offset = 0;
    widget.controller.onDrag = (dx) {
      setState(() {
        offset += dx * 2;
      });
    };
    final _color = (widget.index & 1 == 0)
        ? Colors.cyan.shade200
        : Colors.blue.shade400;
    widget.controller.resetColor = () {
      color = _color;
    };
    widget.controller.resetColor!();
    widget.controller.setColor = (color) {
      this.color = color;
      setState(() {});
    };
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    if (offset <= 0) {
      timer?.cancel();
      offset = 0;
    } else if (offset >= 100) {
      offset = 100;
      timer?.cancel();
    } else if (offset < 90) {
      timer?.cancel();
      timer = Timer.periodic(const Duration(milliseconds: 1), (t) {
        setState(() {
          offset -= ((120 - offset) / 20).toInt();
        });
      });
    } else {
      offset = 100;
      timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTab(widget.location),
      child: Container(
        width: widget.size.width,
        height: widget.size.height,
        child: OverflowBox(
          fit: OverflowBoxFit.max,
          maxWidth: widget.size.width + 200,
          child: Padding(
            padding: EdgeInsetsGeometry.only(left: offset),
            child: Row(
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                    fixedSize: Size(50, widget.size.height),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(),
                  ),
                  icon: Icon(Icons.cancel, color: Colors.white),
                  onPressed: () => widget.onRemove(widget.index),
                ),
                IconButton(
                  style: IconButton.styleFrom(
                    fixedSize: Size(50, widget.size.height),
                    backgroundColor: Color(0xFF00FF00),
                    shape: RoundedRectangleBorder(),
                  ),
                  icon: Icon(Icons.arrow_downward, color: Colors.white),
                  onPressed: () {
                    widget.onAddBelow(widget.index);
                    setState(() {
                      this.offset -= 20;
                    });
                  },
                ),
                Container(
                  width: widget.size.width * 0.1,
                  height: widget.size.height,
                  color: color,
                  padding: EdgeInsets.zero,
                  alignment: Alignment.center,
                  child: Text(
                    (widget.index + 1).toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Kay Pho Du",
                    ),
                  ),
                ),
                Container(
                  width: widget.size.width * 0.9,
                  height: widget.size.height,
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: BoxBorder.all(color: color, width: 4),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.location.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                              fontFamily: "Kay Pho Du",
                              fontSize: 22,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.timeline, size: 15),
                              Text(
                                " Open time: ${widget.location.openTime} - ${widget.location.closeTime}",
                                style: TextStyle(
                                  fontFamily: "Kay Pho Du",
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "\$ Price: ${widget.location.price}",
                            style: TextStyle(
                              fontFamily: "Kay Pho Du",
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),

                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          width: widget.size.width * 0.3,
                          height: widget.size.height * 0.32,
                          color: color,
                          alignment: Alignment.center,
                          child: Text(
                            widget.location.type,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: "Kay Pho Du",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
