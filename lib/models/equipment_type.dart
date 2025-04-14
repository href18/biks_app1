import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Biks/splash_screen.dart';
import 'package:Biks/views/saver.dart';
import 'package:Biks/views/lift_data_view.dart';

class EquipmentType {
  EquipmentType({required this.name});
  final String name;
  String? localeName;

  static EquipmentType fromCSV(String name) =>
      EquipmentTypes.allEquipmentTypes.firstWhere((type) => type.name == name);
}

abstract final class EquipmentTypes {
  static void initEquipmentTypesFromAppLocalizations(AppLocalizations locale) {
    fiber.localeName = locale.fiberSling;
    chain80.localeName = locale.chain80;
    chain100.localeName = locale.chain100;
    srFc.localeName = locale.steelRope;
    srIwrc.localeName = locale.steelRopeIWC;
  }

  static EquipmentType fiber = EquipmentType(name: "Fiberstropp");

  static EquipmentType chain80 = EquipmentType(name: "Kjetting (80)");

  static EquipmentType chain100 = EquipmentType(name: "Kjetting (100)");

  static EquipmentType srFc = EquipmentType(name: "Ståltau (fc)");

  static EquipmentType srIwrc = EquipmentType(name: "Ståltau (iwrc)");

  static List<EquipmentType> allEquipmentTypes = [
    EquipmentTypes.fiber,
    EquipmentTypes.chain80,
    EquipmentTypes.chain100,
    EquipmentTypes.srFc,
    EquipmentTypes.srIwrc
  ];
}

bool equipmentTypeIsChain(EquipmentType equipmentType) =>
    equipmentType == EquipmentTypes.chain80 ||
    equipmentType == EquipmentTypes.chain100;
