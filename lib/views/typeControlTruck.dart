import 'dart:io';
import 'package:biks/l10n/app_localizations.dart';
import 'package:biks/utils/share_origin_extension.dart';
import 'package:biks/widgets/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

enum TypeControlCategory { truck, machine, crane }

String _sanitizeTypeControlPdfPart(String? value,
    {String fallback = 'ukjent'}) {
  final sanitized = (value ?? '')
      .trim()
      .replaceAll(RegExp(r'\s+'), '_')
      .replaceAll(RegExp(r'[^\w.-]'), '');
  return sanitized.isEmpty ? fallback : sanitized;
}

// This screen will be for the Type Control / Forklift Training form.
class TypeControlScreen extends StatefulWidget {
  const TypeControlScreen({super.key});

  @override
  _TypeControlScreenState createState() => _TypeControlScreenState();
}

class _TypeControlScreenState extends State<TypeControlScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _traineeNameController = TextEditingController();
  final TextEditingController _trainerNameController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _equipmentNumberController =
      TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime _trainingDate = DateTime.now();
  TypeControlCategory _selectedCategory = TypeControlCategory.truck;
  String? _selectedType;
  bool _checklistInitialized = false;
  List<ChecklistItem> _checklistItems = [];

  final List<String> _truckTypes = [
    'T1',
    'T2',
    'T3',
    'T4',
    'T5',
    'T6',
    'T7',
    'T8',
    'T8.1',
    'T8.2',
    'T8.4'
  ];

  List<String> _machineTypes(AppLocalizations l10n) => [
        l10n.machineTypeExcavator,
        l10n.machineTypeWheelLoader,
        l10n.machineTypeTelehandler,
        l10n.machineTypeDumpTruck,
        l10n.machineTypeOther,
      ];

  List<String> _craneTypes(AppLocalizations l10n) => [
        l10n.craneTypeMobile,
        l10n.craneTypeTower,
        l10n.craneTypeBridgeGantry,
        l10n.craneTypePortal,
        l10n.craneTypeOther,
      ];

  List<String> _currentTypeOptions(AppLocalizations l10n) =>
      _selectedCategory == TypeControlCategory.truck
          ? _truckTypes
          : _selectedCategory == TypeControlCategory.machine
              ? _machineTypes(l10n)
              : _craneTypes(l10n);

  List<ChecklistItem> _buildTruckChecklist(AppLocalizations l10n) => [
        ChecklistItem(l10n.checklistItemLicenseAvailable,
            [l10n.optionYes, l10n.optionNo]),
        ChecklistItem(l10n.checklistItemInstructionManualRead,
            [l10n.optionYes, l10n.optionNo]),
        ChecklistItem(l10n.checklistItemExplainMainParts, [l10n.optionDone]),
        ChecklistItem(l10n.checklistItemExplainLevers, [l10n.optionDone]),
        ChecklistItem(l10n.checklistItemHowToStart, [l10n.optionDone]),
        ChecklistItem(l10n.checklistItemExplainTilt, [l10n.optionDone]),
        ChecklistItem(l10n.checklistItemShowPedals, [l10n.optionDone]),
        ChecklistItem(l10n.checklistItemExplainMarkings, [l10n.optionDone]),
        ChecklistItem(
            l10n.checklistItemExplainLiftingCapacity, [l10n.optionDone]),
        ChecklistItem(
            l10n.checklistItemExplainLiftingDiagram, [l10n.optionDone]),
        ChecklistItem(
            l10n.checklistItemExplainDrivingHeight, [l10n.optionDone]),
        ChecklistItem(
            l10n.checklistItemExplainMaxLiftingCapacity, [l10n.optionDone]),
        ChecklistItem(
            l10n.checklistItemExplainCenterOfGravity, [l10n.optionDone]),
        ChecklistItem(l10n.checklistItemShowDangerousAreas, [l10n.optionDone]),
        ChecklistItem(l10n.checklistItemShowDailyControl, [l10n.optionDone]),
        ChecklistItem(l10n.checklistItemShowTruckCharging,
            [l10n.optionDone, l10n.optionNotApplicable]),
        ChecklistItem(l10n.checklistItemShowBatteryMaintenance,
            [l10n.optionDone, l10n.optionNotApplicable]),
        ChecklistItem(l10n.checklistItemShowProperParking, [l10n.optionDone]),
        ChecklistItem(
            l10n.checklistItemShowCorrectGoodsHandling, [l10n.optionDone]),
        ChecklistItem(l10n.checklistItemShowAdditionalEquipment,
            [l10n.optionDone, l10n.optionNotApplicable]),
        ChecklistItem(
            l10n.checklistItemShowDocumentationStorage, [l10n.optionDone]),
      ];

  List<ChecklistItem> _buildMachineChecklist(AppLocalizations l10n) => [
        ChecklistItem(l10n.machineChecklistItemLicenseAvailable,
            [l10n.optionYes, l10n.optionNo]),
        ChecklistItem(l10n.machineChecklistItemInstructionManualRead,
            [l10n.optionYes, l10n.optionNo]),
        ChecklistItem(
            l10n.machineChecklistItemExplainMainParts, [l10n.optionDone]),
        ChecklistItem(
            l10n.machineChecklistItemExplainControls, [l10n.optionDone]),
        ChecklistItem(
            l10n.machineChecklistItemStartStopProcedures, [l10n.optionDone]),
        ChecklistItem(l10n.machineChecklistItemSafetySystems,
            [l10n.optionDone, l10n.optionNotApplicable]),
        ChecklistItem(l10n.machineChecklistItemRops,
            [l10n.optionDone, l10n.optionNotApplicable]),
        ChecklistItem(l10n.machineChecklistItemAttachmentsTools,
            [l10n.optionDone, l10n.optionNotApplicable]),
        ChecklistItem(
            l10n.machineChecklistItemWorkAreaRisks, [l10n.optionDone]),
        ChecklistItem(
            l10n.machineChecklistItemParkingShutdown, [l10n.optionDone]),
        ChecklistItem(l10n.machineChecklistItemDailyChecks,
            [l10n.optionDone, l10n.optionNotApplicable]),
      ];

  List<ChecklistItem> _buildCraneChecklist(AppLocalizations l10n) => [
        ChecklistItem(
            l10n.craneChecklistLicense, [l10n.optionYes, l10n.optionNo]),
        ChecklistItem(l10n.craneChecklistInstructionManual,
            [l10n.optionYes, l10n.optionNo]),
        ChecklistItem(l10n.craneChecklistMainParts, [l10n.optionDone]),
        ChecklistItem(l10n.craneChecklistControls, [l10n.optionDone]),
        ChecklistItem(l10n.craneChecklistStartStop, [l10n.optionDone]),
        ChecklistItem(l10n.craneChecklistSafetyDevices,
            [l10n.optionDone, l10n.optionNotApplicable]),
        ChecklistItem(l10n.craneChecklistStabilityOutriggers,
            [l10n.optionDone, l10n.optionNotApplicable]),
        ChecklistItem(l10n.craneChecklistLiftingGear,
            [l10n.optionDone, l10n.optionNotApplicable]),
        ChecklistItem(l10n.craneChecklistSignals,
            [l10n.optionDone, l10n.optionNotApplicable]),
        ChecklistItem(l10n.craneChecklistWorkArea,
            [l10n.optionDone, l10n.optionNotApplicable]),
        ChecklistItem(l10n.craneChecklistParking,
            [l10n.optionDone, l10n.optionNotApplicable]),
      ];

  final Map<int, String?> _selectedOptions = {};
  final Map<int, String> _additionalNotes = {};

  bool _showPreview = false;

  void _initializeChecklist(AppLocalizations l10n) {
    if (_selectedCategory == TypeControlCategory.truck) {
      _checklistItems = _buildTruckChecklist(l10n);
    } else if (_selectedCategory == TypeControlCategory.machine) {
      _checklistItems = _buildMachineChecklist(l10n);
    } else {
      _checklistItems = _buildCraneChecklist(l10n);
    }
    _checklistInitialized = true;
  }

  void _onCategoryChanged(TypeControlCategory category, AppLocalizations l10n) {
    setState(() {
      _selectedCategory = category;
      _selectedType = null;
      _equipmentNumberController.clear();
      _selectedOptions.clear();
      _additionalNotes.clear();
      _checklistInitialized = false;
      _showPreview = false;
    });
    _initializeChecklist(l10n);
  }

  String _categoryLabel(AppLocalizations l10n) =>
      _selectedCategory == TypeControlCategory.truck
          ? l10n.typeControlTruckLabel
          : _selectedCategory == TypeControlCategory.machine
              ? l10n.typeControlMachineLabel
              : l10n.typeControlCraneLabel;

  String _trainingHeader(AppLocalizations l10n) =>
      _selectedCategory == TypeControlCategory.truck
          ? l10n.forkliftTypeTrainingHeader
          : _selectedCategory == TypeControlCategory.machine
              ? l10n.machineTypeTrainingHeader
              : l10n.craneTypeTrainingHeader;

  String _informationLabel(AppLocalizations l10n) =>
      _selectedCategory == TypeControlCategory.truck
          ? l10n.truckInformation
          : _selectedCategory == TypeControlCategory.machine
              ? l10n.machineInformation
              : l10n.craneInformation;

  String _typeLabel(AppLocalizations l10n) =>
      _selectedCategory == TypeControlCategory.truck
          ? l10n.truckTypeLabel
          : _selectedCategory == TypeControlCategory.machine
              ? l10n.machineTypeLabel
              : l10n.craneTypeLabel;

  String _numberLabel(AppLocalizations l10n) =>
      _selectedCategory == TypeControlCategory.truck
          ? l10n.truckNumberLabel
          : _selectedCategory == TypeControlCategory.machine
              ? l10n.machineNumberLabel
              : l10n.craneNumberLabel;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _trainingDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _trainingDate) {
      setState(() {
        _trainingDate = picked;
      });
    }
  }

  void _togglePreview() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _showPreview = !_showPreview;
      });
    } else {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.formSnackbarPleaseCompleteFields)),
      );
    }
  }

  @override
  void dispose() {
    _traineeNameController.dispose();
    _trainerNameController.dispose();
    _companyController.dispose();
    _equipmentNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _clearForm() {
    final l10n = AppLocalizations.of(context)!;
    _formKey.currentState?.reset();
    _traineeNameController.clear();
    _trainerNameController.clear();
    _companyController.clear();
    _equipmentNumberController.clear();
    _notesController.clear();
    setState(() {
      _trainingDate = DateTime.now();
      _selectedType = null;
      _selectedOptions.clear();
      _additionalNotes.clear();
      _checklistInitialized = false;
      _showPreview = false; // Go back to form view
    });
    _initializeChecklist(l10n);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.formSnackbarFormCleared)),
    );
  }

  Map<String, dynamic> _getFormData() {
    final l10n = AppLocalizations.of(context)!;
    final currentDate = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    final trainingDateFormatted =
        DateFormat('dd/MM/yyyy').format(_trainingDate);

    final checklistData = _checklistItems.asMap().entries.map((entry) {
      int index = entry.key;
      ChecklistItem item = entry.value;
      return {
        'question': item.question, // Already localized from initialization
        'selectedOption': _selectedOptions[index],
        'additionalNote': _additionalNotes[index],
      };
    }).toList();

    return {
      'formTitle': l10n.typeControlTitle,
      'formSubHeader': _trainingHeader(l10n),
      'category': _categoryLabel(l10n),
      'informationLabel': _informationLabel(l10n),
      'typeLabel': _typeLabel(l10n),
      'numberLabel': _numberLabel(l10n),
      'regulationsSubHeader': l10n.regulationsSubHeader,
      'traineeName': _traineeNameController.text,
      'trainerName': _trainerNameController.text,
      'company': _companyController.text,
      'equipmentType': _selectedType,
      'equipmentNumber': _equipmentNumberController.text,
      'trainingDate': trainingDateFormatted,
      'checklist': checklistData,
      'notes': _notesController.text,
      'dateGenerated': currentDate,
    };
  }

  Widget _buildPreviewRow(String label, String? value) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value ?? l10n.formAnswerNotProvided),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    final l10n = AppLocalizations.of(context)!;
    final formData = _getFormData();
    final typeLabel = formData['typeLabel'] as String? ?? _typeLabel(l10n);
    final numberLabel =
        formData['numberLabel'] as String? ?? _numberLabel(l10n);

    return AppSectionCard(
      title: l10n.formPreviewTitle,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPreviewRow(
              l10n.dateGeneratedLabel, formData['dateGenerated'] as String?),
          _buildPreviewRow(
              l10n.trainingDateLabel, formData['trainingDate'] as String?),
          _buildPreviewRow(l10n.typeControlEquipmentCategory,
              formData['category'] as String?),
          _buildPreviewRow(typeLabel, formData['equipmentType'] as String?),
          _buildPreviewRow(numberLabel, formData['equipmentNumber'] as String?),
          _buildPreviewRow(
              l10n.trainerNameLabel, formData['trainerName'] as String?),
          _buildPreviewRow(
              l10n.traineeNameLabel, formData['traineeName'] as String?),
          _buildPreviewRow(l10n.companyLabel, formData['company'] as String?),
          const SizedBox(height: 16),
          Text(
            l10n.trainingChecklistSection,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...(formData['checklist'] as List<dynamic>).map((item) {
            final question = item['question'] as String;
            final selectedOption = item['selectedOption'] as String?;
            final additionalNote = item['additionalNote'] as String?;
            String displayValue = selectedOption ?? l10n.formAnswerNotSelected;
            if (additionalNote != null && additionalNote.isNotEmpty) {
              displayValue += ' (${l10n.commentsReasonLabel}: $additionalNote)';
            }
            return _buildPreviewRow(question, displayValue);
          }),
          const SizedBox(height: 16),
          _buildPreviewRow(
              l10n.additionalNotesSection, formData['notes'] as String?),
          const SizedBox(height: 32),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ElevatedButton(
                onPressed: _togglePreview,
                child: Text(l10n.formButtonBackToForm)),
            ElevatedButton(
                onPressed: _sharePdfReport, child: Text(l10n.formButtonSend)),
          ]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (!_checklistInitialized) {
      _initializeChecklist(l10n);
    }

    if (_showPreview) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.formPreviewTitle)),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: _buildPreview(),
        ),
      );
    }

    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior:
            HitTestBehavior.opaque, // Ensures taps on empty space are caught
        child: Scaffold(
          appBar: AppBar(
            title: Text(l10n
                .typeControlTitle), // This will be "Type control" or "Type opplæring"
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSectionCard(
                    title: '',
                    child: SegmentedButton<TypeControlCategory>(
                      segments: <ButtonSegment<TypeControlCategory>>[
                        ButtonSegment<TypeControlCategory>(
                            value: TypeControlCategory.crane,
                            label: Text(l10n.typeControlCraneLabel),
                            icon: const Icon(Icons.construction)),
                        ButtonSegment<TypeControlCategory>(
                            value: TypeControlCategory.machine,
                            label: Text(l10n.typeControlMachineLabel),
                            icon: const Icon(Icons.precision_manufacturing)),
                        ButtonSegment<TypeControlCategory>(
                            value: TypeControlCategory.truck,
                            label: Text(l10n.typeControlTruckLabel),
                            icon: const Icon(Icons.forklift)),
                      ],
                      selected: {_selectedCategory},
                      onSelectionChanged: (selection) =>
                          _onCategoryChanged(selection.first, l10n),
                      style: SegmentedButton.styleFrom(
                          selectedForegroundColor: Colors.white,
                          selectedBackgroundColor: theme.colorScheme.primary),
                    ),
                  ),
                  AppSectionCard(
                    title: _trainingHeader(l10n),
                    subtitle: l10n.regulationsSubHeader,
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          initialValue: _selectedType,
                          decoration:
                              InputDecoration(labelText: _typeLabel(l10n)),
                          items: _currentTypeOptions(l10n).map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedType = value;
                            });
                          },
                          validator: (value) => value == null
                              ? l10n.requiredFieldValidator
                              : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _equipmentNumberController,
                          decoration:
                              InputDecoration(labelText: _numberLabel(l10n)),
                          validator: (value) => value?.isEmpty ?? true
                              ? l10n.requiredFieldValidator
                              : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _trainerNameController,
                          decoration:
                              InputDecoration(labelText: l10n.trainerNameLabel),
                          validator: (value) => value?.isEmpty ?? true
                              ? l10n.requiredFieldValidator
                              : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _traineeNameController,
                          decoration:
                              InputDecoration(labelText: l10n.traineeNameLabel),
                          validator: (value) => value?.isEmpty ?? true
                              ? l10n.requiredFieldValidator
                              : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _companyController,
                          decoration:
                              InputDecoration(labelText: l10n.companyLabel),
                          validator: (value) => value?.isEmpty ?? true
                              ? l10n.requiredFieldValidator
                              : null,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(l10n.trainingDateLabel,
                                style: theme.textTheme.titleMedium),
                            TextButton(
                              onPressed: () => _selectDate(context),
                              child: Text(
                                DateFormat('dd/MM/yyyy').format(_trainingDate),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AppSectionCard(
                    title: l10n.trainingChecklistSection,
                    child: Column(
                      children: _checklistItems.asMap().entries.map((entry) {
                        int index = entry.key;
                        ChecklistItem item = entry.value;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.question,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 5),

                            // Render different input types based on options
                            if (item.options.length == 1)
                              CheckboxListTile(
                                title: Text(item.options[0]),
                                value:
                                    _selectedOptions[index] == item.options[0],
                                onChanged: (bool? value) {
                                  FocusScope.of(context)
                                      .unfocus(); // Dismiss keyboard
                                  setState(() {
                                    _selectedOptions[index] =
                                        value == true ? item.options[0] : null;
                                  });
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                              )
                            else
                              Wrap(
                                spacing: 8.0,
                                children: item.options.map((option) {
                                  return FilterChip(
                                    label: Text(option),
                                    selected: _selectedOptions[index] == option,
                                    onSelected: (bool selected) {
                                      FocusScope.of(context)
                                          .unfocus(); // Dismiss keyboard
                                      setState(() {
                                        _selectedOptions[index] =
                                            selected ? option : null;
                                      });
                                    },
                                  );
                                }).toList(),
                              ),

                            // Additional notes field for each item
                            if (_selectedOptions[index] == "No" ||
                                _selectedOptions[index] == "Not applicable")
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: TextFormField(
                                  onChanged: (value) =>
                                      _additionalNotes[index] = value,
                                  decoration: InputDecoration(
                                    labelText: l10n.commentsReasonLabel,
                                    isDense: true,
                                  ),
                                  maxLines: 2,
                                ),
                              ),

                            const SizedBox(height: 15),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  AppSectionCard(
                    title: l10n.additionalNotesSection,
                    child: TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: l10n.additionalNotesHint,
                      ),
                    ),
                  ),
                  AppSectionCard(
                    title: '',
                    child: Center(
                      child: ElevatedButton(
                        onPressed: _togglePreview,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Text(l10n.formButtonPreviewReport),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

Future<Uint8List> _generateTrainingPdfDocument(
    Map<String, dynamic> formData, AppLocalizations l10n) async {
  final equipmentType =
      _sanitizeTypeControlPdfPart(formData['equipmentType'] as String?);
  final equipmentNumber =
      _sanitizeTypeControlPdfPart(formData['equipmentNumber'] as String?);
  final trainee =
      _sanitizeTypeControlPdfPart(formData['traineeName'] as String?);
  final dateLabel = DateFormat('yyyyMMdd').format(DateTime.now());
  final pdf = pw.Document(
    title:
        'Typekontroll_${equipmentType}_${equipmentNumber}_${trainee}_$dateLabel',
    subject: l10n.typeControl,
  );

  pw.Widget buildPdfRow(String label, String? value,
      {bool isChecklistItem = false}) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: isChecklistItem ? 1 : 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
              width:
                  isChecklistItem ? 200 : 150, // Wider for checklist questions
              child: pw.Text('$label:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
          pw.Expanded(child: pw.Text(value ?? l10n.formAnswerNotProvided)),
        ],
      ),
    );
  }

  pw.Widget buildSectionHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 12, bottom: 6),
      child: pw.Text(text,
          style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blueGrey800)),
    );
  }

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        final typeLabel =
            formData['typeLabel'] as String? ?? l10n.truckTypeLabel;
        final numberLabel =
            formData['numberLabel'] as String? ?? l10n.truckNumberLabel;
        final infoHeader = formData['informationLabel'] as String? ??
            l10n.trainingInformationSection;
        List<pw.Widget> content = [
          pw.Header(
            level: 0,
            text: formData['formTitle'] as String,
            textStyle: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blueGrey800),
          ),
          pw.Paragraph(text: formData['formSubHeader'] as String),
          pw.Paragraph(
              text: formData['regulationsSubHeader'] as String,
              style:
                  pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 10)),
          pw.Divider(height: 20),
          buildPdfRow(
              l10n.dateGeneratedLabel, formData['dateGenerated'] as String?),
          pw.SizedBox(height: 10),
          buildSectionHeader(l10n.trainingInformationSection),
          buildPdfRow(
              l10n.trainingDateLabel, formData['trainingDate'] as String?),
          buildPdfRow(l10n.typeControlEquipmentCategory,
              formData['category'] as String?),
          buildSectionHeader(infoHeader),
          buildPdfRow(typeLabel, formData['equipmentType'] as String?),
          buildPdfRow(numberLabel, formData['equipmentNumber'] as String?),
          buildPdfRow(
              l10n.trainerNameLabel, formData['trainerName'] as String?),
          buildPdfRow(
              l10n.traineeNameLabel, formData['traineeName'] as String?),
          buildPdfRow(l10n.companyLabel, formData['company'] as String?),
          pw.SizedBox(height: 10),
          buildSectionHeader(l10n.trainingChecklistSection),
        ];

        final checklist = formData['checklist'] as List<dynamic>;
        for (var item in checklist) {
          final question = item['question'] as String;
          final selectedOption = item['selectedOption'] as String?;
          final additionalNote = item['additionalNote'] as String?;
          String displayValue = selectedOption ?? l10n.formAnswerNotSelected;
          if (additionalNote != null && additionalNote.isNotEmpty) {
            displayValue += ' (${l10n.commentsReasonLabel}: $additionalNote)';
          }
          content
              .add(buildPdfRow(question, displayValue, isChecklistItem: true));
        }

        content.addAll([
          pw.SizedBox(height: 10),
          buildSectionHeader(l10n.additionalNotesSection),
          pw.Paragraph(
              text: formData['notes'] as String? ?? l10n.formAnswerNotProvided),
        ]);

        return content;
      },
    ),
  );
  return pdf.save();
}

extension on _TypeControlScreenState {
  // To allow _sharePdfReport to access state
  Future<void> _sharePdfReport() async {
    final l10n = AppLocalizations.of(context)!;
    final formData = _getFormData();
    final trainingDate = _trainingDate; // For filename and subject
    // The following line is modified to pass only one argument to emailSubjectTypeControl
    // as per the error "Too many positional arguments: 1 expected, but 3 found."
    // For the full 3-argument subject, ensure ARB files are correct and 'flutter gen-l10n' is run.
    final subject = l10n
        .emailSubjectTypeControl(DateFormat('dd.MM.yyyy').format(trainingDate));

    try {
      final Uint8List pdfBytes =
          await _generateTrainingPdfDocument(formData, l10n);
      final tempDir = await getTemporaryDirectory();
      final sanitizedType =
          _sanitizeTypeControlPdfPart(formData['equipmentType'] as String?);
      final equipmentNumber =
          _sanitizeTypeControlPdfPart(formData['equipmentNumber'] as String?);
      final trainee =
          _sanitizeTypeControlPdfPart(formData['traineeName'] as String?);
      final fileName =
          'typekontroll_${sanitizedType}_${equipmentNumber}_${trainee}_${DateFormat('yyyyMMdd').format(trainingDate)}.pdf';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(pdfBytes);

      await SharePlus.instance.share(ShareParams(
          files: [XFile(file.path)],
          subject: subject,
          title: l10n.emailBodyPreamble,
          sharePositionOrigin: context.sharePositionOrigin));
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.formSnackbarReportShared)));
      _clearForm();
    } catch (e) {
      debugPrint('Error sharing PDF report for Type Control: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.formSnackbarEmailFailed(e.toString()))));
    }
  }
}

class ChecklistItem {
  final String question;
  final List<String> options;

  ChecklistItem(this.question, this.options);
}
