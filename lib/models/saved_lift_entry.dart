class SavedLiftEntry {
  final String id;
  final String liftName; // e.g., "Single Leg Chain Sling"
  final String liftKey; // e.g., "single_leg_chain_sling"
  final String
      originalLiftImage; // path to the default image for this lift type
  final String? userSelectedImagePath; // path if user picked one
  final String equipmentTypeName;
  final double weight; // in tons
  final bool isUnsymmetric;
  final String? calculatedLiftParts; // e.g., "2-part"
  final double? calculatedWll; // WLL in tons
  final double? calculatedDiameter; // in mm
  final DateTime timestamp;

  SavedLiftEntry({
    required this.id,
    required this.liftName,
    required this.liftKey,
    required this.originalLiftImage,
    this.userSelectedImagePath,
    required this.equipmentTypeName,
    required this.weight,
    required this.isUnsymmetric,
    this.calculatedLiftParts,
    this.calculatedWll,
    this.calculatedDiameter,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'liftName': liftName,
        'liftKey': liftKey,
        'originalLiftImage': originalLiftImage,
        'userSelectedImagePath': userSelectedImagePath,
        'equipmentTypeName': equipmentTypeName,
        'weight': weight,
        'isUnsymmetric': isUnsymmetric,
        'calculatedLiftParts': calculatedLiftParts,
        'calculatedWll': calculatedWll,
        'calculatedDiameter': calculatedDiameter,
        'timestamp': timestamp.toIso8601String(),
      };

  factory SavedLiftEntry.fromJson(Map<String, dynamic> json) => SavedLiftEntry(
        id: json['id'] as String,
        liftName: json['liftName'] as String,
        liftKey: json['liftKey'] as String,
        originalLiftImage: json['originalLiftImage'] as String,
        userSelectedImagePath: json['userSelectedImagePath'] as String?,
        equipmentTypeName: json['equipmentTypeName'] as String,
        weight: (json['weight'] as num).toDouble(),
        isUnsymmetric: json['isUnsymmetric'] as bool,
        calculatedLiftParts: json['calculatedLiftParts'] as String?,
        calculatedWll: (json['calculatedWll'] as num?)?.toDouble(),
        calculatedDiameter: (json['calculatedDiameter'] as num?)?.toDouble(),
        timestamp: DateTime.parse(json['timestamp'] as String),
      );

  String get displayImagePath => userSelectedImagePath ?? originalLiftImage;
}
