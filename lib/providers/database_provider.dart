import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Biks/models/equipment_config.dart';
import 'package:Biks/providers/equipment_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'database_provider.g.dart';

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
];

@riverpod
class EquipmentConfigFetcher extends _$EquipmentConfigFetcher {
  static Database? _database;
  final String filename = 'liftDataHistory2';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  @override
  Future<List<EquipmentConfig>> build() async {
    return queryConfigs();
  }

  //Unsymetric weight limit is not saved for now. Maybe create new saving logic with hash.

  Future<Database> _initDatabase() async {
    final Directory path = await getApplicationDocumentsDirectory();
    return await openDatabase('$path/$filename', version: 1,
        onCreate: (Database db, int version) async {
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
  $coldatetime TEXT NOT NULL)
''');
    });
  }

  Future<List<EquipmentConfig>> queryConfigs() async {
    final db = await database;
    final List<Map> maps = await db.query(tableName, columns: columns);
    return maps.map(EquipmentConfig.fromMap).toList();
  }

  Future insert(WidgetRef ref) async {
    final db = await database;
    ref.read(equipmentProvider.notifier).id =
        await db.insert(tableName, ref.read(equipmentProvider).toMap());
    state = AsyncData(await queryConfigs());
  }

  Future delete(EquipmentConfig config) async {
    final db = await database;
    await db
        .delete(tableName, where: '$colTableId = ?', whereArgs: [config.id]);
    state = AsyncData(await queryConfigs());
  }

  Future dispose() async {
    final db = await database;
    await db.close();
  }
}
