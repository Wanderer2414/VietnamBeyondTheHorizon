import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vietnambeyondthehorizon/main.dart';

class LoadingManager {
  static Future<void> Function(
    Future<void> Function(BuildContext context) func,
  )?
  _run;
  static Future<void> run(
    BuildContext context,
    Future<void> Function(BuildContext context) func,
  ) async {
    await _run?.call(func);
    // static int _loadingCount = 0;
    // static void Function()? _onUpdateUI;

    // static bool get isLoading => _loadingCount > 0;
    // static void registerCallback(void Function() callback) {
    //   _onUpdateUI = callback;
    // }

    // static void show() {
    //   _loadingCount++;
    //   print("Loading count: ${_loadingCount}");
    //   _onUpdateUI?.call();
    // }

    // static void hide() {
    //   if (_loadingCount > 0) {
    //     _loadingCount--;
    //   }
    //   print("Loading count: ${_loadingCount}");
    //   _onUpdateUI?.call();
  }
}
//   static final ValueNotifier<int> _loadingCount = ValueNotifier<int>(0);

//   static ValueNotifier<bool> get isLoadingNotifier =>
//       ValueNotifier(_loadingCount.value > 0);

//   static void show() {
//     _loadingCount.value++;
//     print("Loading count: ${_loadingCount.value}");
//   }

//   static void hide() {
//     if (_loadingCount.value > 0) {
//       _loadingCount.value--;
//     }
//     print("Loading count: ${_loadingCount.value}");
//   }
// }

class LoadingWrapper extends StatefulWidget {
  final Widget child;
  final Future<void> Function(BuildContext context)? init;

  const LoadingWrapper({super.key, required this.child, this.init});

  @override
  State<LoadingWrapper> createState() => _LoadingWrapperState();
}

class _LoadingWrapperState extends State<LoadingWrapper> with RouteAware {
  int _loadingCount = 0;

  Future<void> _run(Future<void> Function(BuildContext context) func) async {
    if (!mounted) return;
    setState(() => _loadingCount++);
    await func(context);
    if (!mounted) {
      _loadingCount--;
      return;
    }
    setState(() => _loadingCount--);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    LoadingManager._run = _run;
  }

  @override
  void initState() {
    super.initState();
    if (widget.init != null) {
      _loadingCount++;
      widget.init!(context).then((value) {
        setState(() {
          _loadingCount--;
        });
      });
    }
    LoadingManager._run = _run;
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingCount > 0)
      return Stack(children: [widget.child, const LoadingScreen()]);
    return widget.child;
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/backgrounds/loading_screen_1.png"),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            alignment: Alignment.topCenter,

            child: Text(
              "Vietnam\n Beyond The Horizon",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 20,
                fontFamily: 'Gantari',
                fontWeight: FontWeight.w100,
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  width: 250,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(109, 143, 44, 14),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    getQuote(),
                    style: TextStyle(
                      color: Colors.yellow[100],
                      fontSize: 20,
                      fontFamily: 'Gantari',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(width: 15),
                SpinKitFadingCircle(
                  size: 80,
                  itemBuilder: (_, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: index.isEven
                            ? const Color.fromARGB(126, 255, 117, 4)
                            : const Color.fromARGB(157, 255, 211, 13),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String getQuote() {
  Random random = Random();
  int randnum = random.nextInt(3);
  switch (randnum) {
    case 1:
      return "The limit is not the sky. The limit is the mind.";
    case 2:
      return "Focus on the next step, not the whole path";
    case 3:
      return "Every second you wait, something gets better.";

    default:
      return "Enjoying the app? Rate us 5 stars to support future updates!";
  }
}
