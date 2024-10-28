import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VideoDisplay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: VideoListScreen(),
    );
  }
}

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  List<String> videoUrls = [];
  @override
  void initState() {
    super.initState();
    fetchVideoUrls();
  }
  Future<void> fetchVideoUrls() async {
    try{
      final ListResult result = await storage.ref('videos/').listAll();
      for (var item in result.items) {
        String downloadUrl = await item.getDownloadURL();
        videoUrls.add(downloadUrl);
      }
      setState(() {});
    }
    catch(e) {
    print('Error fetching video Urls: $e');
  }   
  } 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child:Text('Videos',style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold,))),backgroundColor: Color.fromARGB(255, 0, 191, 255),elevation: 10,),
      body: videoUrls.isNotEmpty ? 
      ListView.builder(itemCount: videoUrls.length ,itemBuilder: (context, index) {
        String videoUrl = videoUrls[index];
        String decodedUrl = Uri.decodeFull(videoUrl);
        String videoNameWithParams = decodedUrl.split('/').last;
        String videoName = videoNameWithParams.split('?').first;
        videoName = videoName.split('.').first;
        return Padding(padding: const EdgeInsets.symmetric(vertical:10.0),
        child:VideoPlayerWidget(videoUrl: videoUrls[index],videoName: videoName,)
        );
      },
      )
      : Center(child: CircularProgressIndicator()),
    );
  }
}

//VIDEOPLAYERWIDGET

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String videoName;

  VideoPlayerWidget({required this.videoUrl,required this.videoName});
  

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
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))..initialize().then((_) {setState(() {
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => FullScreenVideoPlayer(videoUrl: widget.videoUrl)));
  }
  @override
  Widget build(BuildContext context) {
    //print(widget.videoName);
    return GestureDetector(
      onTap: _toggleControls, 
      child: Center(child:
      Container(
        width: 1000, 
        height: 600, 
        child: Stack(
          children: [
            
            VideoPlayer(_controller),
            Positioned(
              top: 30,
              left:20,
              child: Container(
                color: Colors.black54, // Semi-transparent background for better visibility
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                child: Text(
                  widget.videoName, // Replace with dynamic title if needed
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            if (_showControls) ...[
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  //width:100,
                  color: Colors.black54,
                  //padding: EdgeInsets.all(8.0),
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
      ),)
    );

  }
}


// Fullscreen video player

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
