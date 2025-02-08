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

  @override
  void initState() {
    super.initState();

    // Wait for 3 seconds after animation starts, then show progress indicator
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        showProgressIndicator = true;
      });
    });

    // Navigate to next screen after 5 seconds
    Timer(Duration(seconds: 7), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => OnBoardingScreen(),
          ),
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
              onLoaded: (composition) {
                // Animation duration is available in composition.duration
              },
            ),
            SizedBox(height: 20),
            // Show progress indicator only after 3 seconds
            if (showProgressIndicator)
              CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
