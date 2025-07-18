// import 'dart:async';
import 'category.dart';
import 'gestures.dart';
import 'gesture_category.dart';

import 'package:flutter/foundation.dart' show kIsWeb; // Import kIsWeb
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // For desktop/other platforms
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'; // For web

import 'package:flutter/material.dart';
import 'dart:io' show Platform; // For desktop platform checks
// import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

class LocalDatabase{
  static final LocalDatabase instance = LocalDatabase._instance();
  static Database? _database;

  LocalDatabase._instance();

  Future<Database> get db async{
    _database ??= await initializeDB();
    return _database!;
  }

  Future<Database> initializeDB() async{
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

    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'manuvox.db');
    
    return await openDatabase(
      path, 
      version: 1, 
      onCreate: createDatabase,
      onConfigure: onConfigure,
      onUpgrade: onUpgrade);
  }

  Future createDatabase(Database db, int version) async{
    await db.execute('''
      CREATE TABLE IF NOT EXISTS category (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        sync_status INTEGER DEFAULT 0,
        updated_at timestamp default current_timestamp
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS gestures (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category_fk INTEGER NOT NULL,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (category_fk) REFERENCES category (id) ON DELETE CASCADE
      );
    ''');
  }

  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // Example for a simple upgrade strategy during development: drop and recreate
      await db.execute('DROP TABLE IF EXISTS gestures;');
      await db.execute('DROP TABLE IF EXISTS category;');
      await createDatabase(db, newVersion); // Recreate both tables with new schema
    }
  }
  Future onConfigure(Database db) async{
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // Sync
  // --- Category Operations for Sync (NEW/UPDATED) ---
  // Method to get the latest updated_at timestamp from local categories
  Future<DateTime?> getLastCategoryUpdatedAt() async {
    Database db = await instance.db;
    List<Map<String, dynamic>> result = await db.query(
      'category',
      columns: ['updated_at'],
      orderBy: 'updated_at DESC',
      limit: 1,
    );
    if (result.isNotEmpty && result.first['updated_at'] != null) {
      return DateTime.parse(result.first['updated_at'] as String);
    }
    return null;
  }

  // Method to insert or update a category from remote data
  // This will handle the 'upsert' logic locally
  Future<void> saveCategoryFromRemote(Category category) async {
    Database db = await instance.db;
    // Check if the category already exists by its ID
    List<Map<String, dynamic>> existing = await db.query(
      'category',
      where: 'id = ?',
      whereArgs: [category.id],
    );

    if (existing.isNotEmpty) {
      // Category exists, update it
      await db.update(
        'category',
        category.toMap(), // Ensure toMap includes ID for update, but not for insert
        where: 'id = ?',
        whereArgs: [category.id],
        conflictAlgorithm: ConflictAlgorithm.replace, // Replace if conflict on primary key
      );
    } else {
      // Category does not exist, insert it
      // For new remote items, we want to explicitly provide the ID from the remote.
      await db.insert(
        'category',
        category.toMap(), // toMap should include ID here
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // Similar method for Gestures if needed
  Future<void> saveGestureFromRemote(Gestures gesture) async {
    Database db = await instance.db;
    List<Map<String, dynamic>> existing = await db.query(
      'gestures',
      where: 'id = ?',
      whereArgs: [gesture.id],
    );

    if (existing.isNotEmpty) {
      await db.update(
        'gestures',
        gesture.toMap(),
        where: 'id = ?',
        whereArgs: [gesture.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      await db.insert(
        'gestures',
        gesture.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
  Future<List<GestureWithCategory>> selectGesturesWithCategoryNames() async {
    Database db = await instance.db;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT
        T1.id,
        T1.name,
        T2.name AS category_name, -- Alias category.name to avoid conflict with gesture.name
        T1.category_fk,
        T1.updated_at
      FROM gestures AS T1
      LEFT JOIN category AS T2 ON T2.id = T1.category_fk
      ORDER BY T1.name ASC -- Example: Order by gesture name
    ''');

    // Convert List<Map<String, dynamic>> to List<GestureWithCategory>
    return List.generate(maps.length, (i) => GestureWithCategory.fromMap(maps[i]));
  }

  // 
  // Gestures
  Future<int> insertGesture(Gestures gesture) async{
    Database db = await instance.db;
    return await db.insert('gestures', gesture.toMap());
  }
  Future<List<Map<String, dynamic>>> selectAllGestures() async{
    Database db = await instance.db;
    return await db.query('gestures');
  }
  Future<int> updateGesture(Gestures gesture) async{
    Database db = await instance.db;
    return await db.update('gestures', gesture.toMap(), where: 'id = ?', whereArgs: [gesture.id]);
  }
  Future<int> deleteGesture(Gestures gesture) async{
    Database db = await instance.db;
    return await db.delete('gestures', where: 'id = ?', whereArgs: [gesture.id]);
  }

  // Category
  Future<int> insertCategory(Category category) async{
    Database db = await instance.db;
    return await db.insert('category', category.toMap());
  }
  Future<List<Map<String, dynamic>>> selectAllCategory() async{
    Database db = await instance.db;
    return await db.query('category');
  }
  Future<int> updateCategory(Category category) async{
    Database db = await instance.db;
    return await db.update('gestures', category.toMap(), where: 'id = ?', whereArgs: [category.id]);
  }
  Future<int> deleteCategory(Category category) async{
    Database db = await instance.db;
    return await db.delete('gestures', where: 'id = ?', whereArgs: [category.id]);
  }

  // Parent Category
  Future<void> initializeCategory() async{
    List<Category> initCategories = [
      Category(name: 'Basic'),
      Category(name: 'Alphabet'),
      Category(name: 'Numbers'),
      Category(name: 'Filipino Gestures'),
      Category(name: 'Basic Greetings'),
      Category(name: 'Introducing'),
      Category(name: 'Leave Taking'),
      Category(name: 'Survival Signs'),
      Category(name: 'WH and How Questions'),
      Category(name: 'Months of the Year'),
      Category(name: 'Days of the Week'),
      Category(name: 'Signs Related to Time'),
      Category(name: 'Time Referent'),
      Category(name: 'Physical Characteristics'),
      Category(name: 'Facial Features'),
      Category(name: 'Hairstyles'),
      Category(name: 'SOGIESC')
    ];
    
    for (Category category in initCategories) {
      await insertCategory(category);
    }
  }
}