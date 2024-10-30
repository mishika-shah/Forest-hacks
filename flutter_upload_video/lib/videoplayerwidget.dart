// import 'package:flutter/material.dart';
// import 'package:flutter_upload_video/fullscreenvideoplayer.dart';
// import 'package:video_player/video_player.dart';

// class VideoPlayerWidget extends StatefulWidget {
//   final String videoUrl;
//   final String videoName;

//   VideoPlayerWidget({required this.videoUrl,required this.videoName});
  

//   @override
//   State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
// }

// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {  
//   late VideoPlayerController _controller;
//   bool _showControls = false;
//   double _volume = 1.0;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))..initialize().then((_) {setState(() {
//       _showControls = true;
//     });
//     });
//   }
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _toggleControls() {
//     setState(() {
//       _showControls = !_showControls;
//     });
//     print('Controls toggled: $_showControls');
//   }
//   void _togglePlayPause() {
//     setState(() {
//       if (_controller.value.isPlaying) {
//         _controller.pause();
//       } else {
//         _controller.play();
//       }
//     });
//   }

//   void _toggleFullScreen() {
//     Navigator.push(context, MaterialPageRoute(builder: (context) => FullScreenVideoPlayer(videoUrl: widget.videoUrl)));
//   }
//   @override
//   Widget build(BuildContext context) {
//     //print(widget.videoName);
//     return GestureDetector(
//       onTap: _toggleControls, 
//       child: Center(child:
//       Container(
//         width: 1000, 
//         height: 600, 
//         child: Stack(
//           children: [
            
//             VideoPlayer(_controller),
//             Positioned(
//               top: 30,
//               left:20,
//               child: Container(
//                 color: Colors.black54, // Semi-transparent background for better visibility
//                 padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
//                 child: Text(
//                   widget.videoName, // Replace with dynamic title if needed
//                   style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             if (_showControls) ...[
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: Container(
//                   //width:100,
//                   color: Colors.black54,
//                   //padding: EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         icon: Icon(
//                           _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//                           color: Colors.white,
//                         ),
//                         onPressed: _togglePlayPause,
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.fullscreen, color: Colors.white),
//                         onPressed: _toggleFullScreen,
//                       ),
//                       Slider(
//                         value: _volume,
//                         min: 0,
//                         max: 1,
//                         onChanged: (value) {
//                           setState(() {
//                             _volume = value;
//                             _controller.setVolume(value); 
//                           });
//                         },
//                         activeColor: Colors.white,
//                         inactiveColor: Colors.grey,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),)
//     );

//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_upload_video/fullscreenvideoplayer.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String videoName;

  VideoPlayerWidget({required this.videoUrl, required this.videoName});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _showControls = false;
  double _volume = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {
          _showControls = true;
        });
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
    print('Controls toggled: $_showControls');
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  void _toggleFullScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenVideoPlayer(videoUrl: widget.videoUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleControls,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(8.0), // Add some padding
          child: AspectRatio(
            aspectRatio: 16 / 9, // Maintain a 16:9 aspect ratio
            child: Stack(
              children: [
                VideoPlayer(_controller),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    color: Colors.black54,
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Text(
                      widget.videoName,
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), // Adjusted font size
                    ),
                  ),
                ),
                if (_showControls) ...[
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black54,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                            ),
                            onPressed: _togglePlayPause,
                          ),
                          IconButton(
                            icon: Icon(Icons.fullscreen, color: Colors.white),
                            onPressed: _toggleFullScreen,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}