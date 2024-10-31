import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_upload_video/videolistscreen.dart';

class DemoApp extends StatefulWidget {
  DemoApp({Key? key}) : super(key: key);

  @override
  _DemoAppState createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  FilePickerResult? result;
  String? _fileName;
  PlatformFile? pickedfile;
  bool isLoading = false;
  File? filetoDisplay;

  void pickfile() async {
    try {
      setState(() {
        isLoading = true;
      });

      result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null) {
        _fileName = result!.files.first.name;
        pickedfile = result!.files.first;
        filetoDisplay = File(pickedfile!.path.toString());
        print('File name $_fileName');
        final storageRef = FirebaseStorage.instance.ref('videos/$_fileName');
        await storageRef.putFile(filetoDisplay!);
        Navigator.push(context,
        MaterialPageRoute(builder: (context) => VideoListScreen(role:'Teacher',)));
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: PreferredSize(
          preferredSize:
              const Size.fromHeight(50.0), // Set the height of the AppBar
          child: Container(
            alignment: Alignment.center, // Center the text
            child: const Text(
              'Upload file',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 33, 170, 243),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: isLoading
                ? Column(
                  children: [
                    CircularProgressIndicator(),
                    Text('Uploading...'),
                  ],
                )
                : SizedBox(
                    width: 130, // Set the desired width here
                    child: ElevatedButton(
                      onPressed: () {
                        pickfile();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        //primary: Colors.white, // Background color
                        // onPrimary: Colors.blue, // Text color
                        side: const BorderSide(
                            color: Colors.blue,
                            width: 1), // Border color and width
                        elevation: 5, // Elevation to create the raised effect
                        padding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8), // Padding
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Center the contents of the Row
                        children: [
                          Text(
                            'Pick File',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(
                              width:
                                  2), // Added space between the text and icon
                          Icon(
                            Icons.add,
                            color: Color.fromARGB(255, 33, 170, 243),
                          )
                        ],
                      ),
                    ),
                  ),
          ),
          if (pickedfile != null)
            SizedBox(
                height: 300, width: 400, child: Image.file(filetoDisplay!)),
        ],
      ),
    );
  }
}
