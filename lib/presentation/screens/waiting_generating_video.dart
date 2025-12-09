import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/data/models/game_progress.dart';
import 'package:vietnambeyondthehorizon/data/user/user_account.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/video_screen.dart';

class WaitingGeneratingVideoScreen extends StatefulWidget {
  final UserAccount account;
  
  final Future<String?> Function() onGenerate; 

  const WaitingGeneratingVideoScreen({super.key, required this.account, required this.onGenerate});

  @override
  State<WaitingGeneratingVideoScreen> createState() => _WaitingGeneratingVideoScreenState();
}

class _WaitingGeneratingVideoScreenState extends State<WaitingGeneratingVideoScreen> {
  List<String> _showcasePhotos = [];
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadPhotos();
    _startSlideshow();

    _executeGeneration();
  }

Future<void> _executeGeneration() async {
    try {
      final results = await Future.wait([
        widget.onGenerate(),
        Future.delayed(const Duration(seconds: 4)),
      ]);

      final videoUrl = results[0];

      if (!mounted) return;

      if (videoUrl != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VideoApp(path: videoUrl),
          ),
        );
      } else {
        Navigator.pop(context); 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to generate video. Try again!")),
        );
      }
    } catch (e) {
      print("Error generating: $e");
      if (mounted) Navigator.pop(context);
    }
  }

  void _loadPhotos() {
    final history = GameProgressManager.checkInPhotos;
    
    if (history.isNotEmpty) {
      _showcasePhotos = history;
    } else {
      _showcasePhotos = [
        "assets/backgrounds/checkin0.png", 
      ];
    }
  }

  void _startSlideshow() {

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _showcasePhotos.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, 
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Creating Your Masterpiece",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontFamily: 'Gantari', 
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Compiling your journey moments...",
              style: TextStyle(color: Colors.white60, fontSize: 14),
            ),

            const SizedBox(height: 40),

            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85, 
                height: 250, 
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orangeAccent.withOpacity(0.2), 
                      blurRadius: 20,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 1500), 
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                        child: _buildImageWidget(_showcasePhotos[_currentIndex]),
                      ),
                      
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black45],
                            ),
                          ),
                        ),
                      ),
                      
                      Positioned(
                        top: 15,
                        right: 15,
                        child: _RecordingIndicator(),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 50),

            const SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                color: Colors.orangeAccent,
                strokeWidth: 3,
                backgroundColor: Colors.white10,
              ),
            ),
            
            const SizedBox(height: 20),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Please wait while your journey is being generated. Do not close the app.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget(String path) {
    final Key key = ValueKey<String>(path); 

    if (path.startsWith("http")) {
      return Image.network(
        path, 
        key: key, 
        fit: BoxFit.cover,
        loadingBuilder: (ctx, child, process) => process == null ? child : Container(color: Colors.black),
      );
    } else if (path.startsWith("assets")) {
      return Image.asset(path, key: key, fit: BoxFit.cover);
    } else {
      return Image.file(File(path), key: key, fit: BoxFit.cover);
    }
  }
}

class _RecordingIndicator extends StatefulWidget {
  @override
  State<_RecordingIndicator> createState() => _RecordingIndicatorState();
}

class _RecordingIndicatorState extends State<_RecordingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          "REC",
          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}