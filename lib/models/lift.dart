import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Lift {
  Lift({required this.name, required this.parts, required this.image});
  final String name;
  String? localeName;
  final int parts;
  final String image;

  static Lift fromCSV(String name, int parts) {
    return Lifts.allLifts.firstWhere((lift) =>
        name.toLowerCase() == lift.name.toLowerCase() && parts == lift.parts);
  }

  @override
  int get hashCode => name.hashCode * parts * image.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Lift &&
        other.name == name &&
        other.parts == parts &&
        other.image == image;
  }
}

final class Lifts {
  static void initLiftsFromAppLocalizations(AppLocalizations locale) {
    straightLift.localeName = locale.straightLift;
    snareLift.localeName = locale.snareLift;
    uLift.localeName = locale.uLift;
    ulv.localeName = locale.ulv;
    straight.localeName = locale.straight;
    snare.localeName = locale.snare;
    direct45_60.localeName = locale.direct4560;
    snare45_60.localeName = locale.snare4560;
    direct45_60.localeName = locale.direct4560;
    direct0_45.localeName = locale.direct3;
    snare0_45.localeName = locale.snare3;
    direct451_60.localeName = locale.direct32;
    snare_451_60.localeName = locale.snare32;
  }

  static Lift straightLift =
      Lift(name: "Rett løft", parts: 1, image: "lib/assets/images/1.png");

  static Lift snareLift =
      Lift(name: 'Snaret løft', parts: 1, image: "lib/assets/images/2.png");
  static Lift uLift =
      Lift(name: 'U-løft', parts: 1, image: "lib/assets/images/3.png");
  static Lift ulv =
      Lift(name: 'U-løft vinkel', parts: 1, image: "lib/assets/images/4.png");
  static Lift straight =
      Lift(name: 'Direkte (15-45)', parts: 2, image: "lib/assets/images/5.png");
  static Lift snare =
      Lift(name: 'Snaret (15-45)', parts: 2, image: "lib/assets/images/6.png");
  static Lift direct45_60 =
      Lift(name: 'Direkte (46-60)', parts: 2, image: "lib/assets/images/7.png");
  static Lift snare45_60 =
      Lift(name: 'Snaret (46-60)', parts: 2, image: "lib/assets/images/8.png");
  static Lift direct0_45 =
      Lift(name: 'Direkte (15-45)', parts: 3, image: "lib/assets/images/9.png");
  static Lift snare0_45 =
      Lift(name: 'Snaret (15-45)', parts: 3, image: "lib/assets/images/10.png");
  static Lift direct451_60 = Lift(
      name: 'Direkte (46-60)', parts: 3, image: "lib/assets/images/11.png");
  static Lift snare_451_60 =
      Lift(name: 'Snaret (46-60)', parts: 3, image: "lib/assets/images/12.png");

  static List<Lift> allLifts = [
    Lifts.straightLift,
    Lifts.snareLift,
    Lifts.uLift,
    Lifts.ulv,
    Lifts.straight,
    Lifts.snare,
    Lifts.direct45_60,
    Lifts.snare45_60,
    Lifts.direct0_45,
    Lifts.snare0_45,
    Lifts.direct451_60,
    Lifts.snare_451_60
  ];
}
