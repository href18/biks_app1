import 'dart:math' as math;

import 'package:biks/models/equipment_type.dart';
import 'package:biks/models/lift.dart';
import 'package:biks/models/lift_data.dart'; // Assuming LiftData, StrapLiftData, ChainLiftData are defined here
import 'package:biks/providers/database_provider.dart';
import 'package:flutter/material.dart';

class EquipmentConfig {
  // Fiber slings use the color-based table format.
  // Chain and steel-rope tables share the diameter/recommended-diameter format.
  bool get usesRecommendedDiameterTable =>
      EquipmentTypes.usesRecommendedDiameterTable(equipmentType);

  static const List<double> _workingLoadFactorsByLiftIndex = [
    1.0, // En stropp: rett løft
    0.8, // En stropp: snaret løft (choked)
    2.0, // En stropp: U-løft
    1.7, // En stropp: U-løft vinkel
    1.4, // To stropper: direkte (15-45°)
    1.1, // To stropper: snaret (15-45°)
    1.0, // To stropper: direkte (46-60°)
    0.8, // To stropper: snaret (46-60°)
    2.1, // Tre/fire stropper: direkte (15-45°)
    1.6, // Tre/fire stropper: snaret (15-45°)
    1.5, // Tre/fire stropper: direkte (46-60°)
    1.2, // Tre/fire stropper: snaret (46-60°)
  ];

  EquipmentConfig({
    this.id, // Made id nullable and not required
    required this.equipmentType,
    required this.lift,
    required this.weight,
    required this.isUnsymetric,
    required this.bestLiftData,
    required this.datetime,
    this.userImagePath,
    this.appliedWeightLimit,
    this.unsymmetricReferenceLimit,
    double? symmetricWeightLimit,
  }) : symmetricWeightLimit = symmetricWeightLimit ?? bestLiftData?.weightLimit;

  final EquipmentType equipmentType;
  final Lift lift;
  final double weight;
  final bool isUnsymetric;
  final LiftData? bestLiftData;
  final double? appliedWeightLimit;
  final double? unsymmetricReferenceLimit;
  final double? symmetricWeightLimit;
  final DateTime datetime;
  int? id;
  final String? userImagePath; // <-- ADDED: Field for user image path

  static double? workingLoadFactorForLift(Lift lift) {
    final int index = Lifts.allLifts.indexOf(lift);
    if (index < 0) {
      return null;
    }

    // Customer rule for tension per sling:
    // For multi-leg lifts we use only the four angle/leg-count factors,
    // regardless of whether the hitch is direct or choked.
    if (lift.parts == 2) {
      return switch (index) {
        4 || 5 => 1.4,
        6 || 7 => 1.0,
        _ => null,
      };
    }

    if (lift.parts == 3) {
      return switch (index) {
        8 || 9 => 2.1,
        10 || 11 => 1.5,
        _ => null,
      };
    }

    switch (index) {
      case 0:
      case 1:
        return 1.0;
      case 2:
        return 2.0;
      case 3:
        return 1.7;
      case 4:
      case 5:
        return 1.4;
      case 6:
      case 7:
        return 1.0;
      case 8:
      case 9:
        return 2.1;
      case 10:
      case 11:
        return 1.5;
      default:
        if (index >= _workingLoadFactorsByLiftIndex.length) {
          return null;
        }
        return _workingLoadFactorsByLiftIndex[index];
    }
  }

  Future<
      ({
        LiftData liftData,
        double appliedLimit,
        double symmetricLimit,
        double referenceLimit,
      })> findBestLiftData() async {
    final List<LiftData> liftDatas = await readLiftDataFromCSV(
      'lib/assets/Løftetabeller/${equipmentType.name}.csv',
      usesRecommendedDiameterTable,
      useSingleLegWll: EquipmentTypes.isSteelRope(equipmentType),
    );

    for (final liftData in liftDatas) {
      if (liftData.lift != lift) continue;

      final double symmetricLimit = liftData.weightLimit;
      final (referenceLimit, effectiveLimit) =
          _computeUnsymmetricLimits(liftData, symmetricLimit);
      final double limitToUse = isUnsymetric ? effectiveLimit : symmetricLimit;

      if (limitToUse >= weight) {
        return (
          liftData: liftData,
          appliedLimit: limitToUse,
          symmetricLimit: symmetricLimit,
          referenceLimit: referenceLimit,
        );
      }
    }

    throw Exception('For høy vekt!');
  }

  (double referenceLimit, double unsymmetricLimit) _computeUnsymmetricLimits(
      LiftData liftData, double symmetricLimit) {
    final double csvUnsymmetricLimit = switch (liftData) {
      StrapLiftData data => data.unsymetricWeightLimit,
      ChainLiftData data => data.unsymetricWeightLimit,
      _ => symmetricLimit,
    };

    if (!isUnsymetric) {
      return (symmetricLimit, symmetricLimit);
    }

    return (symmetricLimit, math.min(csvUnsymmetricLimit, symmetricLimit));
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
    final double? appliedWeightLimit,
    final double? symmetricWeightLimit,
    final double? unsymmetricReferenceLimit,
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
      appliedWeightLimit: appliedWeightLimit ?? this.appliedWeightLimit,
      symmetricWeightLimit: symmetricWeightLimit ?? this.symmetricWeightLimit,
      unsymmetricReferenceLimit:
          unsymmetricReferenceLimit ?? this.unsymmetricReferenceLimit,
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
      colUnsymetricWeightLimit: switch (bestLiftData) {
        StrapLiftData data => data.unsymetricWeightLimit,
        ChainLiftData data => data.unsymetricWeightLimit,
        _ => bestLiftData?.weightLimit ?? 0.0,
      },
      colColor: bestLiftData is StrapLiftData
          ? (bestLiftData as StrapLiftData)
              .color
              .toARGB32() // Store the full color value
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

  static EquipmentConfig fromMap(Map<dynamic, dynamic> map) {
    final bool isChain = (map[colIsChain] as int) == 1;
    final double symmetricLimit = map[colWeightLimit] as double;
    final double unsymmetricLimit = map[colUnsymetricWeightLimit] as double;

    final LiftData bestLiftData = isChain
        ? ChainLiftData(
            wll: map[colWll] as double,
            diameter: map[colDiameter] as double,
            weightLimit: symmetricLimit,
            lift: Lift.fromCSV(
                map[colLiftName] as String, map[colLiftParts] as int),
            recomendedDiameter: map[colRecomendedDiameter] as double,
            unsymetricWeightLimit: unsymmetricLimit)
        : StrapLiftData(
            wll: map[colWll] as double,
            diameter: map[colDiameter] as double,
            weightLimit: symmetricLimit,
            lift: Lift.fromCSV(
                map[colLiftName] as String, map[colLiftParts] as int),
            unsymetricWeightLimit: unsymmetricLimit, // Ensure cast
            color: Color(map[colColor] as int));

    final bool isUnsymetricConfig = (map[colIsUnsymetric] as int) == 1;
    final double appliedLimit = isUnsymetricConfig
        ? math.min(symmetricLimit, unsymmetricLimit)
        : symmetricLimit;

    return EquipmentConfig(
      id: map[colTableId] as int,
      equipmentType: EquipmentType.fromCSV(map[colEquipmentType] as String),
      lift: Lift.fromCSV(map[colLiftName] as String, map[colLiftParts] as int),
      weight: map[colWeight] as double,
      isUnsymetric: isUnsymetricConfig,
      datetime: DateTime.parse(map[coldatetime] as String),
      userImagePath: map[colUserImagePath]
          as String?, // <-- ADDED: Deserialization for userImagePath
      bestLiftData: bestLiftData,
      appliedWeightLimit: appliedLimit,
      symmetricWeightLimit: symmetricLimit,
      unsymmetricReferenceLimit: symmetricLimit,
    );
  }
}
