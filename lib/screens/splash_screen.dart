// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
//
// import 'on_boarding_screen.dart';
//
// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   bool showProgressIndicator = false;
//   late Duration animationDuration;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Navigate to next screen after the animation completes + delay
//     Future.delayed(Duration(seconds: 3), () {
//       setState(() {
//         showProgressIndicator = true;
//       });
//     });
//
//     // Navigate after animation ends or 7 seconds max
//     Timer(Duration(seconds: 5), () {
//       Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (_) => OnBoardingScreen()),
//               (route) => false);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Lottie.asset(
//               "assets/netflix.json",
//               repeat: false, // Ensures the animation runs only once
//               onLoaded: (composition) {
//                 animationDuration = composition.duration;
//               },
//             ),
//             SizedBox(height: 20),
//             if (showProgressIndicator) CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation(Colors.red),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'on_boarding_screen.dart';
import 'package:movflix/screens/homescreen.dart';
import 'package:movflix/widgets/bottom_bar_nav.dart';

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

    // Delay to show progress indicator
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        showProgressIndicator = true;
      });
    });

    // Check authentication state and navigate
    Timer(Duration(seconds: 5), () {
      _checkUserStatus();
    });
  }

  void _checkUserStatus() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // User is already signed in, go to HomeScreen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
            (route) => false,
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const BottomNavBar()),
      );
    } else {
      // User is not signed in, go to OnBoardingScreen (or Login)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => OnBoardingScreen()),
            (route) => false,
      );
    }
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
            if (showProgressIndicator)
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
