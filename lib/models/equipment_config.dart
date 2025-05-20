import 'package:biks/models/equipment_type.dart';
import 'package:biks/models/lift.dart';
import 'package:biks/models/lift_data.dart'; // Assuming LiftData, StrapLiftData, ChainLiftData are defined here
import 'package:biks/providers/database_provider.dart';
import 'package:flutter/material.dart';

class EquipmentConfig {
  bool get isChain => EquipmentTypes.isChain(equipmentType);

  EquipmentConfig({
    this.id, // Made id nullable and not required
    required this.equipmentType,
    required this.lift,
    required this.weight,
    required this.isUnsymetric,
    required this.bestLiftData,
    required this.datetime,
    this.userImagePath,
  });

  final EquipmentType equipmentType;
  final Lift lift;
  final double weight;
  final bool isUnsymetric;
  final LiftData? bestLiftData;
  final DateTime datetime;
  int? id;
  final String? userImagePath; // <-- ADDED: Field for user image path

  Future<LiftData> findBestLiftData() async {
    final List<LiftData> liftDatas = await readLiftDataFromCSV(
        'lib/assets/Løftetabeller/${equipmentType.name}.csv', isChain);

    // Corrected condition:
    // This block should execute for unsymmetric lifts that are NOT chains (e.g., straps)
    if (isUnsymetric && !isChain) {
      for (LiftData liftData in liftDatas) {
        StrapLiftData strapLiftData = liftData as StrapLiftData;
        if (strapLiftData.unsymetricWeightLimit >= weight &&
            liftData.lift == lift) {
          return strapLiftData;
        }
      }
      throw Exception('For høy vekt!');
    }

    // This block handles:
    // 1. Symmetric lifts (isUnsymetric is false) for any equipment type.
    // 2. Chain lifts (isChain is true), which are treated as symmetric in this logic.
    return liftDatas.firstWhere(
        (liftData) => liftData.weightLimit >= weight && liftData.lift == lift,
        orElse: () => throw Exception('For høy vekt!'));
  }

  EquipmentConfig copyWith({
    final int? id,
    final EquipmentType? equipmentType,
    final Lift? lift,
    final double? weight,
    final bool? isUnsymetric,
    final LiftData? bestLiftData,
    final DateTime? datetime,
    final String? userImagePath,
  }) {
    return EquipmentConfig(
      id: id,
      equipmentType: equipmentType ?? this.equipmentType,
      lift: lift ?? this.lift,
      weight: weight ?? this.weight,
      isUnsymetric: isUnsymetric ?? this.isUnsymetric,
      bestLiftData: bestLiftData ?? this.bestLiftData,
      datetime: datetime ?? this.datetime,
      userImagePath:
          userImagePath ?? this.userImagePath, // <-- ADDED: copyWith logic
    );
  }

  Map<String, Object?> toMap() {
    final Map<String, Object?> sqlMap = {
      colEquipmentType: equipmentType.name,
      colLiftName: lift.name,
      colLiftParts: lift.parts,
      colWeight: weight,
      colWll: bestLiftData?.wll ?? 0.0,
      colDiameter: bestLiftData?.diameter ?? 0.0,
      colWeightLimit: bestLiftData?.weightLimit ?? 0.0,
      colIsChain: bestLiftData is ChainLiftData ? 1 : 0,
      colIsUnsymetric: isUnsymetric ? 1 : 0,
      colUnsymetricWeightLimit: bestLiftData is StrapLiftData
          ? (bestLiftData as StrapLiftData).unsymetricWeightLimit
          : bestLiftData?.weightLimit ?? 0.0,
      colColor: bestLiftData is StrapLiftData
          ? (bestLiftData as StrapLiftData)
              .color
              .value // Store the full color value
          : 0,
      colRecomendedDiameter: bestLiftData is ChainLiftData
          ? (bestLiftData as ChainLiftData).recomendedDiameter
          : 0.0,
      coldatetime: datetime.toIso8601String(),
      colUserImagePath: userImagePath,
      colOriginalLiftImage: lift.image, // Add original lift image path
    };
    if (id != null) {
      sqlMap[colTableId] = id;
    }
    return sqlMap;
  }

  static EquipmentConfig fromMap(Map<dynamic, dynamic> map) => EquipmentConfig(
        id: map[colTableId] as int,
        equipmentType: EquipmentType.fromCSV(map[colEquipmentType] as String),
        lift:
            Lift.fromCSV(map[colLiftName] as String, map[colLiftParts] as int),
        weight: map[colWeight] as double,
        isUnsymetric: (map[colIsUnsymetric] as int) == 1,
        datetime: DateTime.parse(map[coldatetime] as String),
        userImagePath: map[colUserImagePath]
            as String?, // <-- ADDED: Deserialization for userImagePath
        bestLiftData: (map[colIsChain] as int) == 1
            ? ChainLiftData(
                wll: map[colWll] as double,
                diameter: map[colDiameter] as double,
                weightLimit: map[colWeightLimit] as double,
                lift: Lift.fromCSV(
                    map[colLiftName] as String, map[colLiftParts] as int),
                recomendedDiameter: map[colRecomendedDiameter] as double)
            : StrapLiftData(
                wll: map[colWll] as double,
                diameter: map[colDiameter] as double,
                weightLimit: map[colWeightLimit] as double,
                lift: Lift.fromCSV(
                    map[colLiftName] as String, map[colLiftParts] as int),
                unsymetricWeightLimit:
                    map[colUnsymetricWeightLimit] as double, // Ensure cast
                color: Color(map[colColor] as int)),
      );
}
