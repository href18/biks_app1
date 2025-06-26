import 'package:biks/l10n/app_localizations.dart';

class EquipmentType {
  EquipmentType({required this.name, this.localeName});
  final String name;
  final String? localeName;

  String get displayName => localeName ?? name;

  EquipmentType copyWith({String? name, String? localeName}) {
    return EquipmentType(
      name: name ?? this.name,
      localeName: localeName ?? this.localeName,
    );
  }

  static EquipmentType fromCSV(String name) =>
      EquipmentTypes.allEquipmentTypes.firstWhere((type) => type.name == name);
}

class EquipmentTypes {
  static late EquipmentType fiberSling;
  static late EquipmentType grade80Chain;
  static late EquipmentType grade100Chain;
  static late EquipmentType steelRopeFc;
  static late EquipmentType steelRopeIwrc;

  static List<EquipmentType> get allEquipmentTypes => [
        fiberSling,
        grade80Chain,
        grade100Chain,
        steelRopeFc,
        steelRopeIwrc,
      ];

  static void initialize(AppLocalizations l10n) {
    updateLocalizations(l10n);
  }

  static void updateLocalizations(AppLocalizations l10n) {
    fiberSling =
        EquipmentType(name: "Fiberstropp", localeName: l10n.fiberSling);
    grade80Chain =
        EquipmentType(name: "Kjetting (80)", localeName: l10n.chain80);
    grade100Chain =
        EquipmentType(name: "Kjetting (100)", localeName: l10n.chain100);
    steelRopeFc =
        EquipmentType(name: "Ståltau (fc)", localeName: l10n.steelRope);
    steelRopeIwrc =
        EquipmentType(name: "Ståltau (iwrc)", localeName: l10n.steelRopeIWC);
  }

  static bool isChain(EquipmentType type) {
    return type == grade80Chain || type == grade100Chain;
  }
}
