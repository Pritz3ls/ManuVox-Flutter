import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

// This class defines your main application widget
class ManuVoxApp extends StatelessWidget {
  const ManuVoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ManuVox', // Title of the application
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark, // Overall dark theme
        primarySwatch: Colors.blue, // Primary color swatch
        visualDensity: VisualDensity.adaptivePlatformDensity, // Adapts density based on platform
      ),
      home: const SplashScreen(), // The initial screen of your app
    );
  }
}
