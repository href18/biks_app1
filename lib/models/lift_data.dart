import 'package:flutter/services.dart';
import 'package:Biks/models/lift.dart';
import 'package:Biks/utils/utils.dart';

abstract class LiftData {
  const LiftData(
      {required this.wll,
      required this.diameter,
      required this.weightLimit,
      required this.lift});
  final double wll;
  final double diameter;
  final double weightLimit;
  final Lift lift;
}

class StrapLiftData extends LiftData {
  StrapLiftData(
      {required super.wll,
      required super.diameter,
      required super.weightLimit,
      required super.lift,
      required this.unsymetricWeightLimit,
      required this.color});

  final double unsymetricWeightLimit;
  final Color color;
}

class ChainLiftData extends LiftData {
  ChainLiftData(
      {required super.wll,
      required super.diameter,
      required super.weightLimit,
      required super.lift,
      required this.recomendedDiameter});
  final double recomendedDiameter;
}

int partsFromIndex(int index) {
  switch (index) {
    case < 6:
      return 1;
    case < 10:
      return 2;
    case < 14:
      return 3;
  }
  return 0;
}

int indexFromIndex(int index) {
  switch (index) {
    case < 6:
      return 2;
    case < 10:
      return 6;
    case < 14:
      return 10;
  }
  return 0;
}

int toUnsymetricIndex(int symetricIndex) {
  switch (symetricIndex) {
    case < 6:
      return symetricIndex;
    case < 8:
      return symetricIndex - 4;
    case < 10:
      return symetricIndex - 6;
    default:
      return symetricIndex - 4;
  }
}

Future<List<LiftData>> readLiftDataFromCSV(String csvPath, bool isChain) async {
  final List<LiftData> liftDatas = [];
  final String csvString = await rootBundle.loadString(csvPath);
  final List<String> csvStringList = csvString.split('\n');
  final List<String> headers = csvStringList[0].split(";");
  for (int i = 1; i < csvStringList.length; i++) {
    final List<String> row = csvStringList[i].split(";");
    if (row.length >= 13) {
      for (int j = 2; j < row.length; j++) {
        final LiftData liftData = isChain
            ? ChainLiftData(
                wll: double.parse(row[indexFromIndex(j)]),
                diameter: double.parse(row[0]),
                weightLimit: double.parse(row[j]),
                lift: Lift.fromCSV(headers[j], partsFromIndex(j)),
                recomendedDiameter: double.parse(row[1]))
            : StrapLiftData(
                wll: double.parse(row[2]),
                diameter: double.parse(row[1]),
                weightLimit: double.parse(row[j]),
                lift: Lift.fromCSV(headers[j], partsFromIndex(j)),
                color: row[0].toColor(),
                unsymetricWeightLimit: double.parse(row[toUnsymetricIndex(j)]));
        liftDatas.add(liftData);
      }
    }
  }
  return liftDatas;
}
