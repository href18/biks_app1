import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Lift {
  final String name; // Internal identifier
  final int parts; // Number of parts
  final String image; // Asset path
  String? localeName; // Localized display name

  Lift({
    required this.name,
    required this.parts,
    required this.image,
    this.localeName,
  });

  String get displayName => localeName ?? name;

  Lift copyWith({
    String? name,
    int? parts,
    String? image,
    String? localeName,
  }) {
    return Lift(
      name: name ?? this.name,
      parts: parts ?? this.parts,
      image: image ?? this.image,
      localeName: localeName ?? this.localeName,
    );
  }

  static Lift fromCSV(String name, int parts) {
    final searchNameLower = name.toLowerCase();
    return Lifts.allLifts.firstWhere(
      (lift) =>
          lift.name.toLowerCase() == searchNameLower && lift.parts == parts,
      orElse: () => throw Exception('Lift not found: $name (${parts} parts)'),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Lift && other.name == name && other.parts == parts;
  }

  @override
  int get hashCode => name.hashCode ^ parts.hashCode;
}

final class Lifts {
  // Direct initialization of all lifts
  static Lift straightLift = Lift(
    name: "Rett løft",
    parts: 1,
    image: "lib/assets/images/1.png",
  );

  static Lift snareLift = Lift(
    name: "Snaret løft",
    parts: 1,
    image: "lib/assets/images/2.png",
  );

  static Lift uLift = Lift(
    name: "U-løft",
    parts: 1,
    image: "lib/assets/images/3.png",
  );

  static Lift ulv = Lift(
    name: "U-løft vinkel",
    parts: 1,
    image: "lib/assets/images/4.png",
  );

  static Lift straight = Lift(
    name: "Direkte (15-45)",
    parts: 2,
    image: "lib/assets/images/5.png",
  );

  static Lift snare = Lift(
    name: "Snaret (15-45)",
    parts: 2,
    image: "lib/assets/images/6.png",
  );

  static Lift direct45_60 = Lift(
    name: "Direkte (46-60)",
    parts: 2,
    image: "lib/assets/images/7.png",
  );

  static Lift snare45_60 = Lift(
    name: "Snaret (46-60)",
    parts: 2,
    image: "lib/assets/images/8.png",
  );

  static Lift direct0_45 = Lift(
    name: "Direkte (15-45)",
    parts: 3,
    image: "lib/assets/images/9.png",
  );

  static Lift snare0_45 = Lift(
    name: "Snaret (15-45)",
    parts: 3,
    image: "lib/assets/images/10.png",
  );

  static Lift direct451_60 = Lift(
    name: "Direkte (46-60)",
    parts: 3,
    image: "lib/assets/images/11.png",
  );

  static Lift snare451_60 = Lift(
    name: "Snaret (46-60)",
    parts: 3,
    image: "lib/assets/images/12.png",
  );

  // Initialize translations
  static void initializeLocalizations(AppLocalizations l10n) {
    updateLocalizations(l10n);
  }

  // Update translations when language changes
  static void updateLocalizations(AppLocalizations l10n) {
    straightLift = straightLift.copyWith(localeName: l10n.straightLift);
    snareLift = snareLift.copyWith(localeName: l10n.snareLift);
    uLift = uLift.copyWith(localeName: l10n.uLift);
    ulv = ulv.copyWith(localeName: l10n.ulv);
    straight = straight.copyWith(localeName: l10n.straight);
    snare = snare.copyWith(localeName: l10n.snare);
    direct45_60 = direct45_60.copyWith(localeName: l10n.direct4560);
    snare45_60 = snare45_60.copyWith(localeName: l10n.snare4560);
    direct0_45 = direct0_45.copyWith(localeName: l10n.direct3);
    snare0_45 = snare0_45.copyWith(localeName: l10n.snare3);
    direct451_60 = direct451_60.copyWith(localeName: l10n.direct32);
    snare451_60 = snare451_60.copyWith(localeName: l10n.snare32);
  }

  static List<Lift> get allLifts => [
        straightLift,
        snareLift,
        uLift,
        ulv,
        straight,
        snare,
        direct45_60,
        snare45_60,
        direct0_45,
        snare0_45,
        direct451_60,
        snare451_60,
      ];
}
