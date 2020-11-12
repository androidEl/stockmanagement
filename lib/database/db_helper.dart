import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:stockmanagement/model/item_model.dart';

class DbHelper {
  static const databaseName = 'product.db';

  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + databaseName;
    var productDatabase = openDatabase(path, version: 1, onCreate: _createDb);
    return productDatabase;
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE product(id INTEGER PRIMARY KEY AUTOINCREMENT,sku TEXT,name TEXT,stock INTEGER,price INTEGER,productImg TEXT)
    ''');
  }
}
