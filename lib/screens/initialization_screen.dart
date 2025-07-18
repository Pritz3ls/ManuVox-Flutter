import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'dart:async'; // Import for using Timer

class InitializationScreen extends StatefulWidget{
  const InitializationScreen({super.key});
  @override
  State<InitializationScreen> createState() => _InitializationScreenState();
}

class _InitializationScreenState extends State<InitializationScreen> {
  Timer? _virtualLoadingTime;
  final Duration _loadingDuration = const Duration(seconds: 3);

  @override
  void initState(){
    super.initState();
    startLoadingTime();
  }

  void startLoadingTime(){
    _virtualLoadingTime = Timer.periodic(_loadingDuration, (timer){
      setState((){
        Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const CameraScreen())
        );
      });
    });
  }

  @override
  void dispose(){
    _virtualLoadingTime?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D), // Dark background color
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            const Text(
              'Initializing',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please wait patiently as we\'re getting everything ready for you, Thank you.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Tip: You can check the gesture references to learn how to do sign language!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}