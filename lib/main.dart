import 'package:auth_firebase_application/pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyAfdQTtPjOOWXuPklBcbnRh55CiJ-PNjJg',
          appId: '1:540416922759:android:ad48f53f72da5c0a7ad422',
          messagingSenderId: '540416922759',
          projectId: 'fir-application-edfab'));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Flutter FireBase",
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
