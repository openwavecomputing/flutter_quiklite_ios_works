import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../app_database.dart';
import 'location_row.dart';

class LocationOperations {
  // Singleton approach
  static final LocationOperations _instance = LocationOperations._internal();

  factory LocationOperations() => _instance;

  LocationOperations._internal();

  //! C --> CRUD = Create
  Future<void> createLocationTable(Database db, String textType) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $locationTable (
        ${LocationFields.locationLatLong} $textType,
        ${LocationFields.timeStamp} $textType
      )
      ''');
  }

  //! C --> CRUD = Create
  Future<LocationRow> addLocation(LocationRow locationRow) async {
    final db = await AppDatabase.instance.database;
    final id = await db.insert(
      locationTable,
      locationRow.toMap(),
    );

    return locationRow.copy(locationLatLong: id.toString());
  }

  // Get All Location
  Future<List<LocationRow>> readAllLocation() async {
    final db = await AppDatabase.instance.database;

    final result = await db.query(locationTable);

    return result.map((tbcData) => LocationRow.fromMap(tbcData)).toList();
  }

  //! D --> CRUD = Delete
  Future<void> deleteAllLocation() async {
    final db = await AppDatabase.instance.database;
    debugPrint("DB deleteAllLocation");
    return await db.execute(''' DELETE FROM $locationTable ''');
  }
}
