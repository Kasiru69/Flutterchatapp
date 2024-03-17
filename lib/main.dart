import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterchatapp/Home.dart';
import 'package:flutterchatapp/Login_page.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(apiKey: "AIzaSyALCq8ms5xesJgPqoxWs1cz4Wan7KYuV1Y",
          authDomain: "flutter-chat-app-bdb5a.firebaseapp.com",
          databaseURL: "https://flutter-chat-app-bdb5a-default-rtdb.firebaseio.com/",
          projectId: "flutter-chat-app-bdb5a",
          messagingSenderId: "999406064493",
          appId: "1:999406064493:android:72c7b3d6985465a7ce4064",)
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirebaseAuth.instance.currentUser==null?Login():Home(),
    );
  }
}
