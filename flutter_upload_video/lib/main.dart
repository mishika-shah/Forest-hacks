import 'package:flutter/material.dart';
import 'package:flutter_upload_video/demo_app.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key?key}):super(key:key);

@override
Widget build(BuildContext context){
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DemoApp(),
  );
}
}