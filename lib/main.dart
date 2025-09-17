import 'package:flutter/material.dart';
import 'splash_screen.dart'; // Make sure this file is in the same 'lib' folder

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BashaLagbe',
      theme: ThemeData( // <--- Cursor is here
        // This sets the default font for the entire app to 'Inter'
        fontFamily: 'Inter',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // This removes the "debug" banner from the top-right corner
      debugShowCheckedModeBanner: false,
      // This sets your SplashScreen as the first page the user sees
      home: const SplashScreen(),
    );

  }
}