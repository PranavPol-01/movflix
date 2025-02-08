import 'package:flutter/material.dart';
import 'package:movflix/widgets/custom_theme.dart';

import 'pages/sign_in_page.dart';
import 'pages/sign_up_page.dart';

import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovFlix ',
      theme: darkTheme,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
