import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class VideoApp extends StatefulWidget {
  final String path;
  const VideoApp({super.key, required this.path});

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;
  bool _isSaving = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.path))
      ..initialize().then((_) {
        _controller.play();
        Future.delayed(Duration(seconds: 2), () {
          if (mounted) setState(() => _showControls = false);
        });
        setState(() {});
      });

    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        setState(() => _showControls = true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls && _controller.value.isPlaying) {
      Future.delayed(Duration(seconds: 3), () {
        if (mounted && _controller.value.isPlaying) {
          setState(() => _showControls = false);
        }
      });
    }
  }

  Future<void> _saveVideo() async {
    if (!await Gal.hasAccess()) {
      await Gal.requestAccess();
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      String videoUrl = widget.path;

      final tempDir = await getTemporaryDirectory();

      final String savePath =
          '${tempDir.path}/journey_${DateTime.now().millisecondsSinceEpoch}.mp4';

      await Dio().download(
        videoUrl,
        savePath,
        onReceiveProgress: (count, total) {
          print("Downloading: ${(count / total * 100).toStringAsFixed(0)}%");
        },
      );

      await Gal.putVideo(savePath, album: "VietnamJourney");

      File(savePath).delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text("Saved to Gallery successfully!"),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      print("Save video error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to save: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 10),
                      Text(
                        "Loading your journey...",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
          ),

          GestureDetector(
            onTap: _toggleControls,
            behavior: HitTestBehavior.translucent,
            child: Container(
              color: _showControls ? Colors.black45 : Colors.transparent,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          if (_showControls && _controller.value.isInitialized)
            Center(
              child: IconButton(
                iconSize: 80,
                color: Colors.white.withOpacity(0.9),
                icon: Icon(
                  _controller.value.position >= _controller.value.duration
                      ? Icons.replay_circle_filled_rounded
                      : _controller.value.isPlaying
                      ? Icons.pause_circle_filled_rounded
                      : Icons.play_circle_fill_rounded,
                ),
                onPressed: () {
                  setState(() {
                    if (_controller.value.position >=
                        _controller.value.duration) {
                      _controller.seekTo(Duration.zero);
                      _controller.play();
                    } else {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    }
                  });
                },
              ),
            ),

          // 4. THANH TIẾN TRÌNH (Ở dưới đáy)
          if (_showControls && _controller.value.isInitialized)
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                    colors: VideoProgressColors(
                      playedColor: Colors.amber,
                      bufferedColor: Colors.white24,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDurationText(_controller.value.position),
                      _buildDurationText(_controller.value.duration),
                    ],
                  ),
                ],
              ),
            ),

          Positioned(
            top: 50,
            left: 20,
            child: SafeArea(
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),

          if (_showControls)
            Positioned(
              top: 50,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),

                  _isSaving
                      ? CircularProgressIndicator(color: Colors.white)
                      : CircleAvatar(
                          backgroundColor: Colors.black54,
                          child: IconButton(
                            icon: Icon(
                              Icons.download_rounded,
                              color: Colors.white,
                            ),
                            onPressed: _saveVideo,
                            tooltip: "Save to Gallery",
                          ),
                        ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDurationText(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Text(
      "$minutes:$seconds",
      style: TextStyle(color: Colors.white70, fontSize: 12),
    );
  }
}
