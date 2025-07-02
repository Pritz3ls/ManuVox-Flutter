import '../objects/local_database.dart'; // Import the DatabaseHelper class
import '../objects/sync_service.dart'; // Import the DatabaseHelper class

import 'package:flutter/foundation.dart' show kIsWeb; // Import kIsWeb
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // For desktop/other platforms
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'; // For web

import 'dart:io' show Platform; // For desktop platform checks

import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'dart:async'; // Import for using Timer

class FinalizationScreen extends StatefulWidget{
  const FinalizationScreen({super.key});
  @override
  State<FinalizationScreen> createState() => _FinalizationScreenState();
}

class _FinalizationScreenState extends State<FinalizationScreen> {
  Timer? _virtualLoadingTime;
  final Duration _loadingDuration = const Duration(seconds: 3);

  @override
  void initState() async{
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    // Initialize FFI for desktop platforms if needed
    if (kIsWeb) {
      // Use the web factory for Flutter web
      databaseFactory = databaseFactoryFfiWeb;
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Use the ffi factory for desktop platforms
      sqfliteFfiInit(); // Initialize FFI for desktop
      databaseFactory = databaseFactoryFfi;
    }
    
    await LocalDatabase.instance.initializeDB();
    // await LocalDatabase.instance.initializeCategory();

    await SyncService().performFullPullSync();
    
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
              'Finalizing',
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