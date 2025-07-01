// import 'dart:async';
import 'category.dart';
import 'gestures.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase{
  static final LocalDatabase instance = LocalDatabase._instance();
  static Database? _database;

  LocalDatabase._instance();

  Future<Database> get db async{
    _database ??= await initializeDB();
    return _database!;
  }

  Future<Database> initializeDB() async{
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'manuvox.db');
    
    return await openDatabase(path, version: 1, onCreate: createDatabase);
  }

  Future createDatabase(Database db, int version) async{
    await db.execute('''
      CREATE TABLE IF NOT exists category (
        id SERIAL NOT NULL PRIMARY KEY ,
        name TEXT NOT NULL,
        updated_at timestamp default current_timestamp
      );
    ''');
  }

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