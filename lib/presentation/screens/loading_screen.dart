import 'dart:async';

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
    setState(() {
      _loadingCount++;
      print("loading count: $_loadingCount");
    });
    await func(context);
    if (!mounted) {
      _loadingCount--;
      return;
    }
    setState(() {
      _loadingCount--;
      print("loading count: $_loadingCount");
    });
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
    print("Change run!");
  }

  @override
  void initState() {
    super.initState();
    if (widget.init != null) {
      _loadingCount++;
      widget.init!(context).then((value) {
        print("Loading count: 0");
        setState(() {
          _loadingCount--;
        });
      });
    }
    LoadingManager._run = _run;
  }

  @override
  Widget build(BuildContext context) {
    print("LOADING COUNTTT: $_loadingCount");
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
  Timer? _timer;
  int _seconds = 0;
  String _quote = "";

  @override
  void initState() {
    super.initState();
    _quote = getQuote();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _seconds++;
        });
      }
    });
  }

  String get _timerText {
    final int minutes = _seconds ~/ 60;
    final int seconds = _seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                color: const Color.fromARGB(255, 121, 68, 0),
                fontSize: 24,
                fontFamily: 'Gantari',
                fontWeight: FontWeight.normal,
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
                    color: const Color.fromARGB(180, 143, 44, 14),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _quote,
                    style: TextStyle(
                      color: Colors.yellow[100],
                      fontSize: 20,
                      fontFamily: 'Gantari',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SpinKitFadingCircle(
                      size: 70,
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

                    SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 211, 13),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _timerText,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Courier',
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

String getQuote() {
  final List<String> quotes = [
    "The journey of a thousand miles begins with a single step.",
    "Not all those who wander are lost.",
    "Collect moments, not things.",
    "Life is either a daring adventure or nothing at all.",
    "Travel is the only thing you buy that makes you richer.",
    "Adventure awaits beyond the horizon.",
    "Don't listen to what they say. Go see.",
    "To travel is to live.",
    "The limit is not the sky. The limit is the mind.",
    "Focus on the next step, not the whole path.",
    "Dream big. Start small. Act now.",
    "Believe you can and you're halfway there.",
    "Your potential is endless.",
    "Great things never came from comfort zones.",
    "Difficult roads often lead to beautiful destinations.",
    "Every second you wait, something gets better.",
    "Good things come to those who wait.",
    "Patience is not the ability to wait, but the ability to keep a good attitude while waiting.",
    "Loading your next adventure...",
    "Preparing the magic just for you...",
    "Almost there... Great views take time!",
    "Enjoying the app? Rate us 5 stars to support future updates!",
  ];

  return quotes[Random().nextInt(quotes.length)];
}
