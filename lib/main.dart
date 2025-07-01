import 'package:flutter/material.dart';
import '../objects/local_database.dart'; // Import the DatabaseHelper class
// import '../objects/gestures.dart';

// import 'package:flutter/material.dart';
// import '../objects/category.dart';

import 'package:flutter/foundation.dart' show kIsWeb; // Import kIsWeb
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // For desktop/other platforms
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'; // For web
import 'dart:io' show Platform; // For desktop platform checks
import 'screens/database_tester.dart';

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

  // Set the database factory for sqflite
  // This is crucial for desktop and testing environments.
  // On mobile (iOS/Android), sqflite's default factory is usually sufficient
  // unless you specifically want to use FFI there too.
  
  await LocalDatabase.instance.initializeDB();
  await LocalDatabase.instance.initializeCategory();

  runApp(DatabaseTester());
}
