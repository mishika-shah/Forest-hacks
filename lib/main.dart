import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:storing/firebase_options.dart';
//import 'package:storing/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp(); // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); //Initialize Firebase
}

class VideoUploaderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Uploader',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: VideoUploader(),
    );
  }
}

class VideoUploader extends StatefulWidget {
  @override
  _VideoUploaderState createState() => _VideoUploaderState();
}

class _VideoUploaderState extends State<VideoUploader> {
  final ImagePicker _picker = ImagePicker();
  File? _video;

  // Request necessary permissions at runtime
  Future<void> _requestPermission() async {
    if (Platform.isAndroid) {
      // Check for Android 13+ media permissions
      var status = await Permission.mediaLibrary.request();
      if (!status.isGranted) {
        status = await Permission.storage.request();
        if (!status.isGranted) {
          throw Exception("Storage permission is required.");
        }
      }
    }
  }

  // Pick video from gallery
  Future<void> _pickVideo() async {
    try {
      await _requestPermission(); // Request permission before picking

      final XFile? pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _video = File(pickedFile.path);
        });
      } else {
        print("No video selected");
      }
    } catch (e) {
      print("Error picking video: $e");
    }
  }

  // Upload video to Firebase Storage
  Future<void> _uploadVideo() async {
    if (_video == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a video first")),
      );
      return;
    }

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child("videos/${DateTime.now().millisecondsSinceEpoch}.mp4");

      await storageRef.putFile(_video!);

      final downloadUrl = await storageRef.getDownloadURL();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Video uploaded! URL: $downloadUrl")),
      );
    } catch (e) {
      print("Error uploading video: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload video")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Uploader"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickVideo,
              child: Text("Pick Video from Gallery"),
            ),
            const SizedBox(height: 20),
            if (_video != null)
              Text("Selected Video: ${_video!.path.split('/').last}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadVideo,
              child: Text("Upload Video"),
            ),
          ],
        ),
      ),
    );
  }
}
