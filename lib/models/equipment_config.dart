import 'package:flutter/material.dart';
import 'package:Biks/models/equipment_type.dart';
import 'package:Biks/models/lift.dart';
import 'package:Biks/models/lift_data.dart';
import 'package:Biks/providers/database_provider.dart';

class EquipmentConfig {
  EquipmentConfig({
    required this.id,
    required this.equipmentType,
    required this.lift,
    required this.weight,
    required this.isUnsymetric,
    required this.bestLiftData,
    required this.datetime,
  });

  final String equipmentType;
  final Lift lift;
  final double weight;
  final bool isUnsymetric;
  final LiftData? bestLiftData;
  final DateTime datetime;
  int? id;

  Future<LiftData> findBestLiftData() async {
    final List<LiftData> liftDatas = await readLiftDataFromCSV(
        'lib/assets/Løftetabeller/$equipmentType.csv',
        equipmentTypeIsChain(equipmentType));

    if (isUnsymetric && !equipmentTypeIsChain(equipmentType)) {
      for (LiftData liftData in liftDatas) {
        StrapLiftData strapLiftData = liftData as StrapLiftData;
        if (strapLiftData.unsymetricWeightLimit >= weight &&
            liftData.lift == lift) {
          return strapLiftData;
        }
      }
      throw Exception('For høy vekt!');
    }

    return liftDatas.firstWhere(
        (liftData) => liftData.weightLimit >= weight && liftData.lift == lift,
        orElse: () => throw Exception('For høy vekt!'));
  }

  EquipmentConfig copyWith({
    final int? id,
    final String? equipmentType,
    final Lift? lift,
    final double? weight,
    final bool? isUnsymetric,
    final LiftData? bestLiftData,
    final DateTime? datetime,
  }) {
    return EquipmentConfig(
        id: id,
        equipmentType: equipmentType ?? this.equipmentType,
        lift: lift ?? this.lift,
        weight: weight ?? this.weight,
        isUnsymetric: isUnsymetric ?? this.isUnsymetric,
        bestLiftData: bestLiftData ?? this.bestLiftData,
        datetime: datetime ?? this.datetime);
  }

  Map<String, Object?> toMap() {
    final Map<String, Object?> sqlMap = {
      colEquipmentType: equipmentType,
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
          ? (bestLiftData as StrapLiftData).color.r
          : 0,
      colRecomendedDiameter: bestLiftData is ChainLiftData
          ? (bestLiftData as ChainLiftData).recomendedDiameter
          : 0.0,
      coldatetime: datetime.toIso8601String()
    };
    if (id != null) {
      sqlMap[colTableId] = id;
    }
    return sqlMap;
  }

  static EquipmentConfig fromMap(Map<dynamic, dynamic> map) => EquipmentConfig(
      id: map[colTableId] as int,
      equipmentType: map[colEquipmentType] as String,
      lift: Lift.fromCSV(map[colLiftName] as String, map[colLiftParts] as int),
      weight: map[colWeight] as double,
      isUnsymetric: (map[colIsUnsymetric] as int) == 1,
      datetime: DateTime.parse(map[coldatetime] as String),
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
              unsymetricWeightLimit: map[colUnsymetricWeightLimit],
              color: Color(map[colColor] as int)));
}
