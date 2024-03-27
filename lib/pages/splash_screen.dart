import 'package:auth_firebase_application/authentication/login_authentication.dart';
import 'package:auth_firebase_application/authentication/pin_login_authentication.dart';
import 'package:auth_firebase_application/pages/login.dart';
import 'package:auth_firebase_application/pages/pin_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');

    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    Future.delayed(Duration(seconds: 3), () {
      if (isLoggedIn()) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            create: (context) => AuthBloc_Pin(),
            child: Pingen(),
          ),
        ));
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => BlocProvider(
              create: (context) => AuthBloc(),
              child: Login(),
            ),
          ),
        );
      }
    });
  }

  bool isLoggedIn() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
          child: Text(
        "FireBase Application",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.0),
      )),
    );
  }
}
