import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class MyDatabase {

  Database? _database;

  Future<Database?> get database async {
    if(_database == null) {
      _database = await initialDatabase();
      return _database;
    }
    else {
      return _database;
    }
  }

  Future<Database> initialDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = '$databasePath/todo.db';
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database database, int version) async {
    debugPrint('Database Created');
    String sql = '''
    CREATE TABLE tasks (
      id TEXT, 
      title TEXT,
      body TEXT,
      dateInMilliseconds INTEGER,
      startTime TEXT,
      endTime TEXT,
      reminder TEXT,
      color INTEGER,
      isComplected TEXT,
      isFavorite TEXT
    )
    ''';
    await database.execute(sql);
  }

  Future<List<Map<String, dynamic>>> selectData(String sql) async {
    Database? db = await database;
    List<Map<String, dynamic>> response = await db!.rawQuery(sql);
    return response;
  }

  Future<int> insertData(String sql) async {
    Database? db = await database;
    int response = await db!.rawInsert(sql);
    return response;
  }

  Future<int> updateData(String sql) async {
    Database? db = await database;
    int response = await db!.rawUpdate(sql);
    return response;
  }

  Future<int> deleteData(String sql) async {
    Database? db = await database;
    int response = await db!.rawDelete(sql);
    return response;
  }
}