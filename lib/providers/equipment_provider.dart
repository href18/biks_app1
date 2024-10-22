import 'package:flutter/material.dart';
import 'package:Biks/models/equipment_config.dart';
import 'package:Biks/models/equipment_type.dart';
import 'package:Biks/models/lift.dart';
import 'package:Biks/models/lift_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'equipment_provider.g.dart';

@riverpod
class Equipment extends _$Equipment {
  @override
  EquipmentConfig build() => EquipmentConfig(
        equipmentType: EquipmentTypes.fiber,
        lift: Lifts.allLifts[0],
        weight: 0,
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

  set lift(Lift lift) {
    state = state.copyWith(lift: lift);
  }

  set equipmentType(String equipmentType) {
    state = state.copyWith(equipmentType: equipmentType);
  }

  set datetime(DateTime datetime) {
    state = state.copyWith(datetime: datetime);
  }
}
