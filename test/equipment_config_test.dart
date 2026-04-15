import 'package:biks/models/equipment_config.dart';
import 'package:biks/models/equipment_type.dart';
import 'package:biks/models/lift.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    EquipmentTypes.fiberSling = EquipmentType(name: 'Fiberstropp');
    EquipmentTypes.grade80Chain = EquipmentType(name: 'Kjetting (80)');
    EquipmentTypes.grade100Chain = EquipmentType(name: 'Kjetting (100)');
    EquipmentTypes.steelRopeFc = EquipmentType(name: 'Ståltau (fc)');
    EquipmentTypes.steelRopeIwrc = EquipmentType(name: 'Ståltau (iwrc)');
  });

  group('workingLoadFactorForLift', () {
    test('uses four shared factors for multi-leg lifts', () {
      expect(EquipmentConfig.workingLoadFactorForLift(Lifts.straight), 1.4);
      expect(EquipmentConfig.workingLoadFactorForLift(Lifts.snare), 1.4);
      expect(EquipmentConfig.workingLoadFactorForLift(Lifts.direct45_60), 1.0);
      expect(EquipmentConfig.workingLoadFactorForLift(Lifts.snare45_60), 1.0);

      expect(EquipmentConfig.workingLoadFactorForLift(Lifts.direct0_45), 2.1);
      expect(EquipmentConfig.workingLoadFactorForLift(Lifts.snare0_45), 2.1);
      expect(EquipmentConfig.workingLoadFactorForLift(Lifts.direct451_60), 1.5);
      expect(EquipmentConfig.workingLoadFactorForLift(Lifts.snare451_60), 1.5);
    });

    test('keeps single-leg factors unchanged', () {
      expect(EquipmentConfig.workingLoadFactorForLift(Lifts.straightLift), 1.0);
      expect(EquipmentConfig.workingLoadFactorForLift(Lifts.snareLift), 1.0);
      expect(EquipmentConfig.workingLoadFactorForLift(Lifts.uLift), 2.0);
      expect(EquipmentConfig.workingLoadFactorForLift(Lifts.ulv), 1.7);
    });
  });

  group('fasit regression cases', () {
    test(
        'matches asymmetrical and symmetrical sling selections from the answer key',
        () async {
      final cases = <({
        EquipmentType equipmentType,
        Lift lift,
        double weight,
        bool isUnsymmetric,
        double expectedDiameter,
      })>[
        (
          equipmentType: EquipmentType(name: 'Fiberstropp'),
          lift: Lifts.snare,
          weight: 3.5,
          isUnsymmetric: false,
          expectedDiameter: 40,
        ),
        (
          equipmentType: EquipmentType(name: 'Ståltau (fc)'),
          lift: Lifts.snare,
          weight: 3.5,
          isUnsymmetric: false,
          expectedDiameter: 18,
        ),
        (
          equipmentType: EquipmentType(name: 'Kjetting (80)'),
          lift: Lifts.snare,
          weight: 3.5,
          isUnsymmetric: false,
          expectedDiameter: 13,
        ),
        (
          equipmentType: EquipmentType(name: 'Fiberstropp'),
          lift: Lifts.snare451_60,
          weight: 5.2,
          isUnsymmetric: false,
          expectedDiameter: 50,
        ),
        (
          equipmentType: EquipmentType(name: 'Ståltau (iwrc)'),
          lift: Lifts.snare451_60,
          weight: 5.2,
          isUnsymmetric: false,
          expectedDiameter: 20,
        ),
        (
          equipmentType: EquipmentType(name: 'Kjetting (100)'),
          lift: Lifts.snare451_60,
          weight: 5.2,
          isUnsymmetric: false,
          expectedDiameter: 13,
        ),
        (
          equipmentType: EquipmentType(name: 'Fiberstropp'),
          lift: Lifts.snare0_45,
          weight: 4.7,
          isUnsymmetric: true,
          expectedDiameter: 50,
        ),
        (
          equipmentType: EquipmentType(name: 'Ståltau (fc)'),
          lift: Lifts.snare0_45,
          weight: 4.7,
          isUnsymmetric: true,
          expectedDiameter: 20,
        ),
        (
          equipmentType: EquipmentType(name: 'Kjetting (100)'),
          lift: Lifts.snare0_45,
          weight: 4.7,
          isUnsymmetric: true,
          expectedDiameter: 13,
        ),
        (
          equipmentType: EquipmentType(name: 'Fiberstropp'),
          lift: Lifts.straight,
          weight: 2.9,
          isUnsymmetric: false,
          expectedDiameter: 30,
        ),
        (
          equipmentType: EquipmentType(name: 'Ståltau (iwrc)'),
          lift: Lifts.straight,
          weight: 2.9,
          isUnsymmetric: false,
          expectedDiameter: 14,
        ),
        (
          equipmentType: EquipmentType(name: 'Kjetting (80)'),
          lift: Lifts.straight,
          weight: 2.9,
          isUnsymmetric: false,
          expectedDiameter: 10,
        ),
        (
          equipmentType: EquipmentType(name: 'Fiberstropp'),
          lift: Lifts.snare0_45,
          weight: 2.6,
          isUnsymmetric: true,
          expectedDiameter: 30,
        ),
        (
          equipmentType: EquipmentType(name: 'Ståltau (fc)'),
          lift: Lifts.snare0_45,
          weight: 2.6,
          isUnsymmetric: true,
          expectedDiameter: 16,
        ),
        (
          equipmentType: EquipmentType(name: 'Kjetting (100)'),
          lift: Lifts.snare0_45,
          weight: 2.6,
          isUnsymmetric: true,
          expectedDiameter: 8,
        ),
      ];

      for (final testCase in cases) {
        final config = EquipmentConfig(
          equipmentType: testCase.equipmentType,
          lift: testCase.lift,
          weight: testCase.weight,
          isUnsymetric: testCase.isUnsymmetric,
          bestLiftData: null,
          datetime: DateTime(2026, 3, 4),
        );

        final result = await config.findBestLiftData();
        expect(result.liftData.diameter, testCase.expectedDiameter);
      }
    });

    test('matches answer-key capacities for reference questions', () async {
      final ropeConfig = EquipmentConfig(
        equipmentType: EquipmentType(name: 'Ståltau (fc)'),
        lift: Lifts.straight,
        weight: 6.0,
        isUnsymetric: false,
        bestLiftData: null,
        datetime: DateTime(2026, 3, 4),
      );
      final ropeResult = await ropeConfig.findBestLiftData();
      expect(ropeResult.liftData.diameter, 20);
      expect(ropeResult.symmetricLimit, 6.0);

      final chainConfig = EquipmentConfig(
        equipmentType: EquipmentType(name: 'Kjetting (100)'),
        lift: Lifts.snare451_60,
        weight: 19.2,
        isUnsymetric: false,
        bestLiftData: null,
        datetime: DateTime(2026, 3, 4),
      );
      final chainResult = await chainConfig.findBestLiftData();
      expect(chainResult.liftData.diameter, 20);
      expect(chainResult.symmetricLimit, 19.2);
    });
  });
}
