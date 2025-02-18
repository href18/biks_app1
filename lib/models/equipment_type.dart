abstract final class EquipmentTypes {
  static String fiber = 'Fiberstropp';

  static String chain80 = 'Kjetting (80)';

  static String chain100 = 'Kjetting (100)';

  static String srFc = 'Ståltau (fc)';

  static String srIwrc = 'Ståltau (iwrc)';

  static List<String> allEquipmentTypes = [
    EquipmentTypes.fiber,
    EquipmentTypes.chain80,
    EquipmentTypes.chain100,
    EquipmentTypes.srFc,
    EquipmentTypes.srIwrc
  ];
}

bool equipmentTypeIsChain(String equipmentType) =>
    equipmentType == EquipmentTypes.chain80 ||
    equipmentType == EquipmentTypes.chain100;
