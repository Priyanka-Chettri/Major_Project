import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maj_project/Login_Page.dart';
import 'package:maj_project/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void initState() {
    super.initState();
    Timer(Duration(seconds: 8), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Opacity(
        opacity: 0.5,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/ss.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: const Center(
            child: Text(
              "Flood Alert App",
              style: TextStyle(
                fontSize: 36.0,
                fontFamily: 'RaleWay',
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          ),
        ),
      );
    //);
  }
}
