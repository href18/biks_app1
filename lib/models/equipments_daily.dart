enum EquipmentType { forklift, overheadCrane, mobileCrane, other }

enum PowerSource { electric, diesel, hydraulic, other }

class Equipment {
  final EquipmentType type;
  final String name;
  final PowerSource powerSource;
  final bool isOutdoor;

  Equipment({
    required this.type,
    required this.name,
    required this.powerSource,
    required this.isOutdoor,
  });
}
