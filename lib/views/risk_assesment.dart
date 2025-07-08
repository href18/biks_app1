import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:biks/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A dedicated data class for the Risk Assessment.
class RiskAssessment {
  final String assessorName;
  final String operatorName;
  final String location;
  final String? truckType;
  final String? otherTruckType;
  final String? powerSource;
  final Map<String, bool> checklist;
  final String? comments;
  final DateTime date;

  RiskAssessment({
    required this.assessorName,
    required this.operatorName,
    required this.location,
    this.truckType,
    this.otherTruckType,
    this.powerSource,
    required this.checklist,
    this.comments,
    required this.date,
  });

  /// Converts the object to a JSON map for saving to SharedPreferences.
  Map<String, dynamic> toJson() => {
        'assessorName': assessorName,
        'operatorName': operatorName,
        'location': location,
        'truckType': truckType,
        'otherTruckType': otherTruckType,
        'powerSource': powerSource,
        'checklist': checklist,
        'comments': comments,
        'date': date.toIso8601String(),
      };

  /// Creates a RiskAssessment object from a JSON map.
  factory RiskAssessment.fromJson(Map<String, dynamic> json) => RiskAssessment(
        assessorName: json['assessorName'] ?? '',
        operatorName: json['operatorName'] ?? '',
        location: json['location'] ?? '',
        truckType: json['truckType'],
        otherTruckType: json['otherTruckType'],
        powerSource: json['powerSource'],
        checklist: Map<String, bool>.from(json['checklist'] ?? {}),
        comments: json['comments'],
        date: json['date'] != null
            ? DateTime.parse(json['date'])
            : DateTime.now(),
      );
}

/// The main UI screen for the Risk Assessment.
class RiskAssessmentScreen extends StatelessWidget {
  const RiskAssessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the l10n object for localization
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.riskAssessmentTruck),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: const SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: _RiskAssessmentFormWidget(),
        ),
      ),
    );
  }
}

/// The stateful widget that manages the form's state.
class _RiskAssessmentFormWidget extends StatefulWidget {
  const _RiskAssessmentFormWidget();
  @override
  State<_RiskAssessmentFormWidget> createState() =>
      _RiskAssessmentFormWidgetState();
}

class _RiskAssessmentFormWidgetState extends State<_RiskAssessmentFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _assessorNameController = TextEditingController();
  final TextEditingController _operatorNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _otherTruckTypeController =
      TextEditingController();
  final TextEditingController _commentsController = TextEditingController();

  static const String _formProgressKey = 'risk_assessment_form_progress';
  String? _selectedTruckType;
  String? _selectedPowerSource;
  final Map<String, bool> _checklist = {};
  bool _isLoading = true;
  bool _showPreview = false;

  // These lists will be populated in didChangeDependencies
  late List<String> _truckTypes;
  late List<Map<String, String>> _areaChecklistItems;
  late List<Map<String, String>> _documentationChecklistItems;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize lists here where context is available
    _initializeLists();
    if (_isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadFormProgress());
      _isLoading = false;
    }
  }

  void _initializeLists() {
    final l10n = AppLocalizations.of(context)!;
    _truckTypes = [
      l10n.truckTypeT1,
      l10n.truckTypeT2,
      l10n.truckTypeT3,
      l10n.truckTypeT4,
      l10n.truckTypeT5,
      l10n.truckTypeOther,
    ];

    _areaChecklistItems = [
      {'key': 'checkArea', 'label': l10n.checkAreaLabel},
      {'key': 'secureArea', 'label': l10n.secureAreaLabel},
      {'key': 'stableLoad', 'label': l10n.stableLoadLabel},
      {'key': 'trafficInOut', 'label': l10n.trafficInOutLabel},
      {'key': 'visualContact', 'label': l10n.visualContactLabel},
      {'key': 'winterConditions', 'label': l10n.winterConditionsLabel},
      {'key': 'deicingSalt', 'label': l10n.deicingSaltLabel},
      {'key': 'hillDriving', 'label': l10n.hillDrivingLabel},
      {'key': 'darkness', 'label': l10n.darknessLabel},
      {'key': 'infoOnDangers', 'label': l10n.infoOnDangersLabel},
      {'key': 'racksCertified', 'label': l10n.racksCertifiedLabel},
    ];

    _documentationChecklistItems = [
      {'key': 'preUseCheck', 'label': l10n.preUseCheckLabel},
      {'key': 'truckCheck', 'label': l10n.truckCheckLabel},
      {'key': 'typeTraining', 'label': l10n.typeTrainingLabel},
      {'key': 'competenceCert', 'label': l10n.competenceCertLabel},
      {'key': 'instructorPresent', 'label': l10n.instructorPresentLabel},
    ];

    // Initialize checklist map after lists are created
    if (_checklist.isEmpty) {
      for (var item in _areaChecklistItems) {
        _checklist[item['key']!] = false;
      }
      for (var item in _documentationChecklistItems) {
        _checklist[item['key']!] = false;
      }
    }
  }

  Future<void> _loadFormProgress() async {
    final l10n = AppLocalizations.of(context)!;
    final prefs = await SharedPreferences.getInstance();
    final String? savedDataJson = prefs.getString(_formProgressKey);

    if (savedDataJson != null) {
      try {
        final assessment = RiskAssessment.fromJson(jsonDecode(savedDataJson));
        setState(() {
          _assessorNameController.text = assessment.assessorName;
          _operatorNameController.text = assessment.operatorName;
          _locationController.text = assessment.location;
          _selectedTruckType = assessment.truckType;
          _otherTruckTypeController.text = assessment.otherTruckType ?? '';
          _selectedPowerSource = assessment.powerSource;
          _commentsController.text = assessment.comments ?? '';
          _checklist.clear();
          for (var item in [
            ..._areaChecklistItems,
            ..._documentationChecklistItems
          ]) {
            _checklist[item['key']!] = false;
          }
          assessment.checklist.forEach((key, value) {
            if (_checklist.containsKey(key)) {
              _checklist[key] = value;
            }
          });
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.formSnackbarProgressLoaded)),
        );
      } catch (e) {
        print("Error loading risk assessment form progress: $e");
      }
    }
  }

  Future<void> _saveFormProgress() async {
    final l10n = AppLocalizations.of(context)!;
    final prefs = await SharedPreferences.getInstance();
    final assessment = _getAssessmentData();
    await prefs.setString(_formProgressKey, jsonEncode(assessment.toJson()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.formSnackbarProgressSaved)),
    );
  }

  Future<void> _clearSavedProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_formProgressKey);
  }

  void _clearForm() {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _formKey.currentState?.reset();
      _assessorNameController.clear();
      _operatorNameController.clear();
      _locationController.clear();
      _selectedTruckType = null;
      _otherTruckTypeController.clear();
      _selectedPowerSource = null;
      _commentsController.clear();
      _checklist.updateAll((key, value) => false);
      _showPreview = false;
    });
    _clearSavedProgress();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.formSnackbarFormCleared)),
    );
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

  RiskAssessment _getAssessmentData() {
    return RiskAssessment(
      assessorName: _assessorNameController.text,
      operatorName: _operatorNameController.text,
      location: _locationController.text,
      truckType: _selectedTruckType,
      otherTruckType: _otherTruckTypeController.text,
      powerSource: _selectedPowerSource,
      checklist: _checklist,
      comments: _commentsController.text,
      date: DateTime.now(),
    );
  }

  Map<String, String> _formatAssessmentDataForDisplay(
      RiskAssessment data, AppLocalizations l10n) {
    final formattedData = <String, String>{};
    formattedData[l10n.date] = DateFormat('yyyy-MM-dd HH:mm').format(data.date);
    formattedData[l10n.assessedBy] =
        data.assessorName.isNotEmpty ? data.assessorName : l10n.notProvided;
    formattedData[l10n.truckDriverName] =
        data.operatorName.isNotEmpty ? data.operatorName : l10n.notProvided;
    formattedData[l10n.area] =
        data.location.isNotEmpty ? data.location : l10n.notProvided;

    String truckTypeDisplay = data.truckType ?? l10n.notSelected;
    if (truckTypeDisplay == l10n.truckTypeOther &&
        data.otherTruckType?.isNotEmpty == true) {
      truckTypeDisplay += ': ${data.otherTruckType}';
    }
    formattedData[l10n.truckType] = truckTypeDisplay;
    formattedData[l10n.powerSource] = data.powerSource ?? l10n.notSelected;

    final allChecklistItems = [
      ..._areaChecklistItems,
      ..._documentationChecklistItems
    ];
    data.checklist.forEach((key, value) {
      final item = allChecklistItems.firstWhere((item) => item['key'] == key,
          orElse: () => {'label': key});
      formattedData[item['label']!] = value ? l10n.done : l10n.notDone;
    });

    formattedData[l10n.actionsAndComments] =
        data.comments?.isNotEmpty == true ? data.comments! : l10n.noComments;
    return formattedData;
  }

  Widget _buildPreview() {
    final l10n = AppLocalizations.of(context)!;
    final assessmentData = _getAssessmentData();
    final formattedData = _formatAssessmentDataForDisplay(assessmentData, l10n);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.previewRiskAssessment,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor)),
            const SizedBox(height: 16),
            ...formattedData.entries.map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.key,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(entry.value),
                      const Divider(),
                    ],
                  ),
                )),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () => setState(() => _showPreview = false),
                    child: Text(l10n.formButtonBackToForm)),
                ElevatedButton(
                    onPressed: () => _sharePdfReport(context),
                    child: Text(l10n.formButtonSend,
                        style: const TextStyle(color: Colors.black))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (_showPreview) {
      return _buildPreview();
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.generalInformation, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          TextFormField(
              controller: _assessorNameController,
              decoration: InputDecoration(labelText: l10n.assessedByName),
              validator: (value) => value == null || value.isEmpty
                  ? l10n.formValidationNotEmpty
                  : null),
          TextFormField(
              controller: _operatorNameController,
              decoration: InputDecoration(labelText: l10n.truckDriverName),
              validator: (value) => value == null || value.isEmpty
                  ? l10n.formValidationNotEmpty
                  : null),
          TextFormField(
              controller: _locationController,
              decoration:
                  InputDecoration(labelText: l10n.areaForRiskAssessment),
              validator: (value) => value == null || value.isEmpty
                  ? l10n.formValidationNotEmpty
                  : null),
          const SizedBox(height: 16),
          Text(l10n.truckInformation, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedTruckType,
            decoration: InputDecoration(labelText: l10n.selectTruckType),
            isExpanded: true,
            items: _truckTypes
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type, overflow: TextOverflow.ellipsis),
                    ))
                .toList(),
            onChanged: (value) => setState(() => _selectedTruckType = value),
            validator: (value) => value == null ? l10n.pleaseSelectAType : null,
          ),
          if (_selectedTruckType == l10n.truckTypeOther)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextFormField(
                  controller: _otherTruckTypeController,
                  decoration: InputDecoration(labelText: l10n.specifyOtherType),
                  validator: (value) => value == null || value.isEmpty
                      ? l10n.formValidationNotEmpty
                      : null),
            ),
          const SizedBox(height: 16),
          Text(l10n.powerSource,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Expanded(
                  child: RadioListTile<String>(
                      title: Text(l10n.electric),
                      value: "El",
                      groupValue: _selectedPowerSource,
                      onChanged: (val) =>
                          setState(() => _selectedPowerSource = val))),
              Expanded(
                  child: RadioListTile<String>(
                      title: Text(l10n.diesel),
                      value: "Diesel",
                      groupValue: _selectedPowerSource,
                      onChanged: (val) =>
                          setState(() => _selectedPowerSource = val))),
            ],
          ),
          if (_selectedPowerSource == null)
            Padding(
                padding: const EdgeInsets.only(left: 12.0, bottom: 8.0),
                child: Text(l10n.pleaseSelectPowerSource,
                    style: TextStyle(
                        color: theme.colorScheme.error, fontSize: 12))),
          const SizedBox(height: 16),
          Text(l10n.riskAssessment, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          ..._areaChecklistItems.map((item) => CheckboxListTile(
                title: Text(item['label']!),
                value: _checklist[item['key']] ?? false,
                onChanged: (bool? value) =>
                    setState(() => _checklist[item['key']!] = value!),
                controlAffinity: ListTileControlAffinity.leading,
              )),
          const SizedBox(height: 16),
          Text(l10n.driverAndDocumentation, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          ..._documentationChecklistItems.map((item) => CheckboxListTile(
                title: Text(item['label']!),
                value: _checklist[item['key']] ?? false,
                onChanged: (bool? value) =>
                    setState(() => _checklist[item['key']!] = value!),
                controlAffinity: ListTileControlAffinity.leading,
              )),
          const SizedBox(height: 16),
          Text(l10n.actionsAndComments, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          TextFormField(
              controller: _commentsController,
              decoration: InputDecoration(
                  labelText: l10n.describeActionsOrComments,
                  border: const OutlineInputBorder()),
              maxLines: 3),
          const SizedBox(height: 32),
          Column(
            children: [
              Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          minimumSize: const Size(double.infinity, 50)),
                      onPressed: _togglePreview,
                      child: Text(l10n.formButtonPreviewInspection,
                          style: const TextStyle(color: Colors.white)))),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: _saveFormProgress,
                      child: Text(l10n.formButtonSaveProgress)),
                  ElevatedButton(
                      onPressed: _clearForm,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent),
                      child: Text(l10n.formButtonClearForm,
                          style: const TextStyle(color: Colors.white))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<Uint8List> _generateAssessmentPdf(
      RiskAssessment assessment, AppLocalizations l10n) async {
    final pdf = pw.Document();

    pw.Widget buildPdfRow(String label, String? value) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 3),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(
                width: 220,
                child: pw.Text('$label:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
            pw.Expanded(child: pw.Text(value ?? l10n.notProvided)),
          ],
        ),
      );
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          String truckTypeDisplay = assessment.truckType ?? l10n.notSelected;
          if (truckTypeDisplay == l10n.truckTypeOther &&
              assessment.otherTruckType?.isNotEmpty == true) {
            truckTypeDisplay += ': ${assessment.otherTruckType}';
          }

          List<pw.Widget> content = [
            pw.Header(
                level: 0,
                text: l10n.riskAssessmentTruck,
                textStyle: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blueGrey800)),
            buildPdfRow(l10n.date,
                DateFormat('yyyy-MM-dd HH:mm').format(assessment.date)),
            pw.Divider(height: 20),
            pw.Header(level: 1, text: l10n.generalInformation),
            buildPdfRow(l10n.assessedBy, assessment.assessorName),
            buildPdfRow(l10n.truckDriverName, assessment.operatorName),
            buildPdfRow(l10n.area, assessment.location),
            pw.SizedBox(height: 10),
            pw.Header(level: 1, text: l10n.truckInformation),
            buildPdfRow(l10n.truckType, truckTypeDisplay),
            buildPdfRow(l10n.powerSource, assessment.powerSource),
            pw.SizedBox(height: 10),
            pw.Header(level: 1, text: l10n.riskAssessment),
          ];

          for (var item in _areaChecklistItems) {
            content.add(buildPdfRow(
                item['label']!,
                assessment.checklist[item['key']!] == true
                    ? l10n.done
                    : l10n.notDone));
          }

          content.addAll([
            pw.SizedBox(height: 10),
            pw.Header(level: 1, text: l10n.driverAndDocumentation),
          ]);

          for (var item in _documentationChecklistItems) {
            content.add(buildPdfRow(
                item['label']!,
                assessment.checklist[item['key']!] == true
                    ? l10n.done
                    : l10n.notDone));
          }

          content.addAll([
            pw.SizedBox(height: 10),
            pw.Header(level: 1, text: l10n.actionsAndComments),
            pw.Paragraph(
                text: assessment.comments?.isNotEmpty == true
                    ? assessment.comments!
                    : l10n.noComments),
          ]);

          return content;
        },
      ),
    );
    return pdf.save();
  }

  Future<void> _sharePdfReport(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final assessmentData = _getAssessmentData();
    final currentDate = DateFormat('yyyy-MM-dd').format(assessmentData.date);
    String operatorName = assessmentData.operatorName.isNotEmpty
        ? assessmentData.operatorName
        : l10n.unknown;
    final sanitizedOperatorName = operatorName
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'[^\w.-]'), '');
    final subject =
        "${l10n.riskAssessmentTruck} - $sanitizedOperatorName - $currentDate";

    try {
      final Uint8List pdfBytes =
          await _generateAssessmentPdf(assessmentData, l10n);
      final tempDir = await getTemporaryDirectory();
      final fileName =
          '${l10n.riskAssessment}_${sanitizedOperatorName}_$currentDate.pdf';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(pdfBytes);

      await SharePlus.instance.share(ShareParams(
          files: [XFile(file.path)],
          subject: subject,
          title: l10n.shareRiskAssessment));

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.formSnackbarReportShared)));
      await _clearSavedProgress();
      _clearForm();
    } catch (e) {
      print('Error sharing PDF report: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.formSnackbarEmailFailed(e.toString()))));
    }
  }
}
