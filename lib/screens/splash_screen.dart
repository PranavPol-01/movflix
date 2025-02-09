import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'on_boarding_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showProgressIndicator = false;
  late Duration animationDuration;

  @override
  void initState() {
    super.initState();

    // Navigate to next screen after the animation completes + delay
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        showProgressIndicator = true;
      });
    });

    // Navigate after animation ends or 7 seconds max
    Timer(Duration(seconds: 7), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => OnBoardingScreen()),
              (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              "assets/netflix.json",
              repeat: false, // Ensures the animation runs only once
              onLoaded: (composition) {
                animationDuration = composition.duration;
              },
            ),
            SizedBox(height: 20),
            if (showProgressIndicator) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
