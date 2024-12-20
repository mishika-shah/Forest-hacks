import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_upload_video/demo_app.dart';
import 'package:flutter_upload_video/videoplayerwidget.dart';

class VideoListScreen extends StatefulWidget {
  //const VideoListScreen({super.key});
  final String role;
  const VideoListScreen({super.key, required this.role});
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
      appBar: AppBar(
        title: Center(
          child: Text(
            'Videos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 0, 191, 255),
        elevation: 10,
         actions: [
        IconButton(
          icon: Icon(Icons.upload_file),
          onPressed: () {
            if (widget.role == 'Teacher') {
              // Navigate to the Upload Video Screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DemoApp()),
              );
            } else {
              // Show message for students
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Students cannot upload files.')),
              );
            }
          },
        ),
      ],
      ),
      //backgroundColor: Colors.black, // Set the background color to black
      body: videoUrls.isNotEmpty
          ? ListView.builder(
              itemCount: videoUrls.length,
              itemBuilder: (context, index) {
                String videoUrl = videoUrls[index]; 
                String decodedUrl = Uri.decodeFull(videoUrl);
                String videoNameWithParams = decodedUrl.split('/').last;
                String videoName = videoNameWithParams.split('?').first;
                videoName = videoName.split('.').first;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: VideoPlayerWidget(
                    videoUrl: videoUrls[index],
                    videoName: videoName,
                  ),
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}