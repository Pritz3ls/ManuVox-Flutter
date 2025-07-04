import 'package:flutter/material.dart';
import 'objects/local_database.dart';
import 'objects/sync_service.dart';
import 'app.dart';

void main() async{
  // Initialize the local database first
  LocalDatabase.instance.initializeDB();
  SyncService.instance.performFullPullSync();
  
  runApp(const ManuVoxApp());
}
