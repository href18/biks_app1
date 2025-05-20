import 'package:biks/models/equipment_config.dart';
import 'package:biks/models/equipment_type.dart';
import 'package:biks/models/lift.dart';
import 'package:biks/models/lift_data.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'equipment_provider.g.dart';

@riverpod
class Equipment extends _$Equipment {
  @override
  EquipmentConfig build() => EquipmentConfig(
        equipmentType: EquipmentTypes.fiberSling,
        lift: Lifts.allLifts[0],
        weight: 0,
        isUnsymetric: false,
        id: null,
        bestLiftData: null,
        datetime: DateTime.now(),
      );

  Future<bool> findBestLiftData() async {
    try {
      final LiftData bestLiftData = await state.findBestLiftData();
      state = state.copyWith(bestLiftData: bestLiftData);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return false;
    }
    return true;
  }

  set id(int id) {
    state = state.copyWith(id: id);
  }

  set weight(double weight) {
    state = state.copyWith(weight: weight);
  }

  set isUnsymetric(bool isUnsymetric) {
    state = state.copyWith(isUnsymetric: isUnsymetric);
  }

  set lift(Lift lift) {
    state = state.copyWith(lift: lift);
  }

  set equipmentType(EquipmentType equipmentType) {
    state = state.copyWith(equipmentType: equipmentType);
  }

  set datetime(DateTime datetime) {
    state = state.copyWith(datetime: datetime);
  }

  set userImagePath(String? path) {
    state = state.copyWith(userImagePath: path);
  }
}
