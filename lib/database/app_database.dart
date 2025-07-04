import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'location/location_operations.dart';
import 'location/location_row.dart';


@immutable
class AppDatabase {
  static const String _databaseName = 'app.db';
  static const int _databaseVersion = 1;

  // Create a singleton
  const AppDatabase._init();

  static const AppDatabase instance = AppDatabase._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    final String path = join(dbPath, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDB,
    );
  }

  //! Create Database method
  Future _createDB(
    Database db,
    int version,
  ) async {
    const idType = 'INTEGER NOT NULL';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER';
    const textUniqueType = 'TEXT NOT NULL UNIQUE';
    // const boolType = 'BOOLEAN NOT NULL';


    // Offline Locations Table to sync later
    await LocationOperations().createLocationTable(db, textType);
  }

//   Future<bool> checkTableExist(String tableName) async{
//     final db = await instance.database;
//     var tables = await db.rawQuery('SELECT * FROM sqlite_master WHERE name=$tableName');
// debugPrint("tables.isEmpty ${tables.isEmpty}");
//     if (tables.isEmpty) {
//       return false;
//     } else{
//       return true;
//     }
//   }

  Future deleteAllTables() async {
    final db = await instance.database;
    db.delete(locationTable);
    debugPrint("DB deleteAllTables");
  }

  Future close() async {
    final db = await instance.database;
    debugPrint("DB close");
    db.close();
  }
}
