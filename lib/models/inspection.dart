class EquipmentInspection {
  final String inspectorName;
  final String inspectorEmail;
  final DateTime inspectionDate;
  final EquipmentType type;
  final String model; // User-entered model
  final Map<String, dynamic> checklist;
  final String? improvements;

  EquipmentInspection({
    required this.inspectorName,
    required this.inspectorEmail,
    required this.inspectionDate,
    required this.type,
    required this.model,
    required this.checklist,
    this.improvements,
  });
}

enum EquipmentType {
  forklift,
  overheadCrane,
  mobileCrane,
}
