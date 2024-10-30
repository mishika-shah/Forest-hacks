import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoPlayer extends StatefulWidget {
  final String videoUrl;
  const FullScreenVideoPlayer({required this.videoUrl});

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _controller;
  double _volume = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))..initialize().then((_) {
      setState(() {
        _controller.play();
      });
    });
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,
      body: Center(
      child:Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: VideoPlayer(_controller),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black54,
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_controller.value.isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.fullscreen_exit, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context); 
                    },
                  ),
                  Slider(
                    value: _volume,
                    min: 0,
                    max: 1,
                    onChanged: (value) {
                      setState(() {
                        _volume = value;
                        _controller.setVolume(value); 
                      });
                    },
                    activeColor: Colors.white,
                    inactiveColor: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
      
    );
  }
}
