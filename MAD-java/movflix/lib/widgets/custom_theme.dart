
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Add this line


get darkTheme => ThemeData(
    primarySwatch: Colors.grey,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    systemOverlayStyle: SystemUiOverlayStyle.light, // Now it will work!
  ),

  inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: Colors.blueGrey),
      labelStyle: TextStyle(color: Colors.white),
    ),
    brightness: Brightness.dark,
    canvasColor: Colors.black,
    colorScheme: ColorScheme.dark(
      primary: Colors.grey,
      secondary: Colors.red, // This replaces accentColor
    ),

  iconTheme: IconThemeData(color: Colors.white),

);