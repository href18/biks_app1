import 'dart:io';

import 'package:biks/providers/equipment_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:developer' as developer; // Import developer for logging

import '../models/equipment_config.dart';
part 'database_provider.g.dart';

// Ensure EquipmentConfig model is imported if not already via equipment_provider

const String tableName = 'LiftDataHistory2';
const String colTableId = '_id';
const String colEquipmentType = 'equipmentType';
const String colLiftName = 'liftName';
const String colLiftParts = 'liftParts';
const String colWeight = 'weight';
const String colWll = 'wll';
const String colDiameter = 'diameter';
const String colWeightLimit = 'weightLimit';
const String colIsChain = 'isChain';
const String colIsUnsymetric = 'isUnsymetric';
const String colUnsymetricWeightLimit = 'unsymetricWeightLimit';
const String colColor = 'color';
const String colRecomendedDiameter = 'recomendedDiameter';
const String coldatetime = 'datetime';
const String colUserImagePath = 'userImagePath'; // Define the new column name
const String colOriginalLiftImage =
    'originalLiftImage'; // For the default lift image
const List<String> columns = [
  colTableId,
  colEquipmentType,
  colLiftName,
  colLiftParts,
  colWeight,
  colWll,
  colDiameter,
  colWeightLimit,
  colIsChain,
  colIsUnsymetric,
  colUnsymetricWeightLimit,
  colColor,
  colRecomendedDiameter,
  coldatetime,
  colUserImagePath, // Add to columns list
  colOriginalLiftImage, // Add to columns list
];

@riverpod
class EquipmentConfigFetcher extends _$EquipmentConfigFetcher {
  static Database? _database;
  final String filename = 'liftDataHistory2';

  Future<Database> get database async {
    developer.log(
        'Accessing database getter. _database is ${_database == null ? "null" : "not null"}. Is open: ${_database?.isOpen}.',
        name: 'EquipmentConfigFetcher.database');
    if (_database != null && _database!.isOpen) {
      developer.log('Database instance already exists and is open.',
          name: 'EquipmentConfigFetcher.database');
      return _database!;
    }
    if (_database != null && !_database!.isOpen) {
      developer.log(
          'Database instance exists but was closed. Setting _database to null before re-initializing.',
          name: 'EquipmentConfigFetcher.database');
      _database = null; // Ensure we re-initialize fully if it was closed
    }
    developer.log('No existing open database instance. Calling _initDatabase.',
        name: 'EquipmentConfigFetcher.database');
    _database = await _initDatabase();
    return _database!;
  }

  @override
  Future<List<EquipmentConfig>> build() async {
    return queryConfigs();
  }

  //Unsymetric weight limit is not saved for now. Maybe create new saving logic with hash.

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    developer.log('Executing _onUpgrade. Old: $oldVersion, New: $newVersion.',
        name: 'EquipmentConfigFetcher._onUpgrade');
    if (oldVersion < 3) {
      // Add columns if they don't exist. Use "IF NOT EXISTS" for safety, though ALTER TABLE usually handles it.
      try {
        developer.log('Attempting to add column $colUserImagePath.',
            name: 'EquipmentConfigFetcher._onUpgrade');
        await db.execute(
            'ALTER TABLE $tableName ADD COLUMN $colUserImagePath TEXT');
        developer.log('Column $colUserImagePath added or already exists.',
            name: 'EquipmentConfigFetcher._onUpgrade');
      } catch (e) {
        developer.log(
            'Error adding column $colUserImagePath (may already exist): $e',
            name: 'EquipmentConfigFetcher._onUpgrade');
      }
      try {
        developer.log('Attempting to add column $colOriginalLiftImage.',
            name: 'EquipmentConfigFetcher._onUpgrade');
        await db.execute(
            'ALTER TABLE $tableName ADD COLUMN $colOriginalLiftImage TEXT');
        developer.log('Column $colOriginalLiftImage added or already exists.',
            name: 'EquipmentConfigFetcher._onUpgrade');
      } catch (e) {
        developer.log(
            'Error adding column $colOriginalLiftImage (may already exist): $e',
            name: 'EquipmentConfigFetcher._onUpgrade');
      }
    }
    developer.log('_onUpgrade complete.',
        name: 'EquipmentConfigFetcher._onUpgrade');
  }

  Future<Database> _initDatabase() async {
    final Directory path = await getApplicationDocumentsDirectory();
    final dbPath = '$path/$filename';
    developer.log('Initializing database at path: $dbPath',
        name: 'EquipmentConfigFetcher._initDatabase');
    try {
      final db = await openDatabase(dbPath, version: 3, // Incremented version
          onCreate: (Database db, int version) async {
        developer.log(
            'Database onCreate called. Version: $version. Creating table $tableName.',
            name: 'EquipmentConfigFetcher._initDatabase');
        // This onCreate is for a fresh database.
        await db.execute('''
CREATE TABLE $tableName (
  $colTableId INTEGER PRIMARY KEY,
  $colEquipmentType TEXT NOT NULL, 
  $colLiftName TEXT NOT NULL, 
  $colLiftParts INTEGER NOT NULL, 
  $colWeight REAL NOT NULL, 
  $colWll REAL NOT NULL,
   
  $colDiameter REAL NOT NULL,
  $colWeightLimit REAL NOT NULL, 
  $colIsChain INTEGER NOT NULL, 
  $colIsUnsymetric INTEGER NOT NULL,
  $colUnsymetricWeightLimit REAL NOT NULL,
  $colColor INTEGER NOT NULL, 
  $colRecomendedDiameter REAL NOT NULL,
  $coldatetime TEXT NOT NULL,
  $colUserImagePath TEXT,
  $colOriginalLiftImage TEXT) 
''');
        developer.log('Table $tableName created.',
            name: 'EquipmentConfigFetcher._initDatabase');
      }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
        developer.log(
            'Database onUpgrade callback triggered. Old: $oldVersion, New: $newVersion.',
            name: 'EquipmentConfigFetcher._initDatabase');
        await _onUpgrade(
            db, oldVersion, newVersion); // Call the separate _onUpgrade method
      });
      developer.log('Database initialized successfully. Path: $dbPath',
          name: 'EquipmentConfigFetcher._initDatabase');
      return db;
    } catch (e, s) {
      developer.log('Error initializing database at path: $dbPath',
          error: e,
          stackTrace: s,
          name: 'EquipmentConfigFetcher._initDatabase');
      rethrow;
    }
  }

  Future<List<EquipmentConfig>> queryConfigs() async {
    final db = await database;
    final List<Map> maps = await db.query(tableName, columns: columns);
    // Log the raw data fetched from the database
    developer.log('Fetched ${maps.length} maps from DB: $maps',
        name: 'EquipmentConfigFetcher.queryConfigs');
    return maps
        .map(EquipmentConfig.fromMap)
        .toList(); // This will fail if any fromMap call fails
  }

  Future<void> insert() async {
    // Changed signature: removed WidgetRef, returns Future<void>
    developer.log('EquipmentConfigFetcher.insert() method started.',
        name: 'EquipmentConfigFetcher.insert.Entry');
    final db = await database;
    developer.log('Database instance obtained in insert().',
        name: 'EquipmentConfigFetcher.insert');

    EquipmentConfig equipmentState;
    try {
      equipmentState = ref.read(equipmentProvider);
      developer.log('equipmentProvider state read successfully in insert().',
          name: 'EquipmentConfigFetcher.insert');
    } catch (e, s) {
      developer.log('Error reading equipmentProvider in insert()',
          error: e, stackTrace: s, name: 'EquipmentConfigFetcher.insert');
      state = AsyncError(e, s);
      return;
    }

    Map<String, dynamic> dataToInsert;
    try {
      dataToInsert = equipmentState.toMap();
      developer.log(
          'equipmentState.toMap() called successfully in insert(). Data: $dataToInsert',
          name: 'EquipmentConfigFetcher.insert');
    } catch (e, s) {
      developer.log('Error calling equipmentState.toMap() in insert()',
          error: e, stackTrace: s, name: 'EquipmentConfigFetcher.insert');
      state = AsyncError(e, s);
      return;
    }
    developer.log('Attempting to insert data: $dataToInsert',
        name: 'EquipmentConfigFetcher.insert');
    try {
      final id = await db.insert(tableName, dataToInsert,
          conflictAlgorithm: ConflictAlgorithm
              .replace); // Or .fail, .ignore depending on desired behavior
      developer.log('Data inserted with ID: $id',
          name: 'EquipmentConfigFetcher.insert');
      if (id <= 0) {
        // Check if insert failed (usually returns row ID > 0 on success)
        final errorMsg =
            'Insert operation failed, returned ID: $id. Data: $dataToInsert';
        developer.log(errorMsg,
            name: 'EquipmentConfigFetcher.insert',
            error: 'Insert returned $id');
        // Set state to error so UI can react
        state = AsyncError(errorMsg, StackTrace.current);
        return; // Stop further processing
      }
    } catch (e, s) {
      developer.log('Error during DB insert. Data: $dataToInsert',
          error: e, stackTrace: s, name: 'EquipmentConfigFetcher.insert');
      state = AsyncError(e, s); // Set state to error
      return; // Stop further processing
    }
    // If insert was successful and id > 0

    state = AsyncData(
        await queryConfigs()); // Refresh the list, will log "Fetched X maps" again
  }

  Future delete(EquipmentConfig config) async {
    final db = await database;
    await db
        .delete(tableName, where: '$colTableId = ?', whereArgs: [config.id]);
    state = AsyncData(await queryConfigs());
  }

  Future dispose() async {
    // This dispose is for the Riverpod provider.
    // We should close the static database instance if it exists and is open.
    if (_database != null && _database!.isOpen) {
      developer.log(
          'Disposing EquipmentConfigFetcher provider: Closing static database instance.',
          name: 'EquipmentConfigFetcher.dispose');
      await _database!.close();
      _database = null; // Clear the static reference as it's now closed.
    } else {
      developer.log(
          'Disposing EquipmentConfigFetcher provider: No open static database instance to close.',
          name: 'EquipmentConfigFetcher.dispose');
    }
  }
}

// IMPORTANT:
// Your EquipmentConfig model (likely in /Users/hakonengfeldt/Dev/biks_app1/lib/models/equipment_config.dart
// or related to /Users/hakonengfeldt/Dev/biks_app1/lib/providers/equipment_provider.dart)
// MUST have:
// 1. A `toMap()` method that returns a Map<String, dynamic> suitable for all columns in the database table.
// 2. A `fromMap(Map<String, dynamic> map)` factory constructor that can create an EquipmentConfig instance from a database row.
// 3. Fields to hold `userImagePath` and `originalLiftImage` (or ensure `fromMap` populates them correctly).
