import 'package:flutter/material.dart';
import '../objects/local_database.dart'; // Import the DatabaseHelper class
import '../objects/sync_service.dart'; // Import the DatabaseHelper class

import 'package:flutter/foundation.dart' show kIsWeb; // Import kIsWeb
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // For desktop/other platforms
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'; // For web

import 'dart:io' show Platform; // For desktop platform checks
// import 'screens/database_tester.dart';
import 'app.dart';

void main() async{
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

  runApp(const ManuVoxApp());
}
