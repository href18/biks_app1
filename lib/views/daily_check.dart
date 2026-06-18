import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:biks/l10n/app_localizations.dart';
import 'package:biks/utils/share_origin_extension.dart';
import 'package:biks/widgets/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:biks/utils/io_utils.dart' as io_utils;
import 'package:biks/utils/pdf_download.dart' as pdf_download;

enum InspectionType { forklift, crane, machine }

class DailyCheckScreen extends StatefulWidget {
  const DailyCheckScreen({super.key});

  @override
  State<DailyCheckScreen> createState() => _DailyCheckScreenState();
}

class _DailyCheckScreenState extends State<DailyCheckScreen> {
  InspectionType _currentInspectionType = InspectionType.forklift;
  static const String _lastTypeKey = 'daily_check_last_type';

  @override
  void initState() {
    super.initState();
    _loadLastType();
  }

  Future<void> _loadLastType() async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getString(_lastTypeKey);
    if (val != null) {
      setState(() {
        _currentInspectionType = InspectionType.values.firstWhere(
            (e) => e.name == val,
            orElse: () => _currentInspectionType);
      });
    }
  }

  Future<void> _persistType(InspectionType type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastTypeKey, type.name);
  }

  String getAppBarTitle(AppLocalizations l10n) {
    switch (_currentInspectionType) {
      case InspectionType.forklift:
        return l10n.dailyCheckForkliftInspectionTitle;
      case InspectionType.crane:
        return l10n.dailyCheckCraneInspectionTitle;
      case InspectionType.machine:
        return l10n.dailyCheckMachineInspectionTitle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(getAppBarTitle(l10n)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppSectionCard(
              title: '',
              margin: EdgeInsets.zero,
              child: SegmentedButton<InspectionType>(
                segments: <ButtonSegment<InspectionType>>[
                  ButtonSegment<InspectionType>(
                      value: InspectionType.crane,
                      label: Text(l10n.dailyCheckCraneLabel),
                      icon: const Icon(Icons.construction)),
                  ButtonSegment<InspectionType>(
                      value: InspectionType.machine,
                      label: Text(l10n.dailyCheckMachineLabel),
                      icon: const Icon(Icons.precision_manufacturing)),
                  ButtonSegment<InspectionType>(
                      value: InspectionType.forklift,
                      label: Text(l10n.dailyCheckForkliftLabel),
                      icon: const Icon(Icons.forklift)),
                ],
                selected: <InspectionType>{_currentInspectionType},
                onSelectionChanged: (Set<InspectionType> newSelection) {
                  setState(() {
                    _currentInspectionType = newSelection.first;
                  });
                  _persistType(_currentInspectionType);
                },
                style: SegmentedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Theme.of(context).primaryColor,
                  selectedForegroundColor: Colors.white,
                  selectedBackgroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          // Wrap the scrollable content with GestureDetector for keyboard dismissal
          Expanded(
            child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                behavior: HitTestBehavior
                    .opaque, // Ensures taps on empty space are caught
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                  child: _buildCurrentForm(),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentForm() {
    if (_currentInspectionType == InspectionType.forklift) {
      return const _ForkliftFormWidget();
    }
    if (_currentInspectionType == InspectionType.crane) {
      return const _CraneFormWidget();
    }
    return const _MachineFormWidget();
  }
}

// --- Forklift Form Widget ---
class _ForkliftFormWidget extends StatefulWidget {
  const _ForkliftFormWidget();

  @override
  State<_ForkliftFormWidget> createState() => _ForkliftFormWidgetState();
}

class _ForkliftFormWidgetState extends State<_ForkliftFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _improvementsController = TextEditingController();

  static const String _formProgressKey = 'forklift_form_progress';
  bool _hasCertificate = false;
  bool _hasManual = false;
  final Map<String, bool> _checklist = {};
  bool _isLoading = true;
  bool _showPreview = false;
  Timer? _autosaveTimer;
  bool _autosaveNotified = false;

  @override
  void initState() {
    super.initState();
    for (var i = 5; i <= 22; i++) {
      _checklist['item_$i'] = false;
    }
  }

  @override
  void dispose() {
    _autosaveTimer?.cancel();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthdateController.dispose();
    _modelController.dispose();
    _improvementsController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadFormProgress());
      _isLoading = false;
    }
  }

  Future<void> _loadFormProgress() async {
    final l10n = AppLocalizations.of(context)!;
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final String? savedDataJson = prefs.getString(_formProgressKey);

    if (savedDataJson != null) {
      try {
        final Map<String, dynamic> savedData = jsonDecode(savedDataJson);
        setState(() {
          _nameController.text = savedData['name'] ?? '';
          _emailController.text = savedData['email'] ?? '';
          _phoneController.text = savedData['phone'] ?? '';
          _birthdateController.text = savedData['birthdate'] ?? '';
          if (savedData['birthdate'] != null &&
              savedData['birthdate'].isNotEmpty) {
            DateFormat('dd/MM/yyyy').parse(savedData['birthdate']);
          }
          _modelController.text = savedData['model'] ?? '';
          _hasCertificate = savedData['hasCertificate'] ?? false;
          _hasManual = savedData['hasManual'] ?? false;
          _improvementsController.text = savedData['improvements'] ?? '';
          if (savedData['checklist'] != null) {
            final Map<String, dynamic> cl = savedData['checklist'];
            cl.forEach((key, value) {
              if (_checklist.containsKey(key)) {
                _checklist[key] = value as bool;
              }
            });
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.formSnackbarProgressLoaded)),
        );
      } catch (e) {
        debugPrint("Error loading forklift form progress: $e");
      }
    }
  }

  Future<void> _clearSavedProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_formProgressKey);
  }

  void _clearForm() {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _formKey.currentState?.reset();
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _birthdateController.clear();
      _modelController.clear();
      _hasCertificate = false;
      _hasManual = false;
      _improvementsController.clear();
      _checklist.updateAll((key, value) => false);
      _showPreview = false;
    });
    _clearSavedProgress();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.formSnackbarFormCleared)),
    );
  }

  Future<void> _confirmAndClearForm() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.formButtonClearForm),
        content: const Text('Er du sikker på at du vil tømme skjemaet?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l10n.cancel)),
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(l10n.formButtonClearForm)),
        ],
      ),
    );
    if (confirmed == true) {
      _clearForm();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthdateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Widget _buildChecklistItem(String label, String key) {
    return CheckboxListTile(
      title: Text(label),
      value: _checklist[key] ?? false,
      onChanged: (bool? value) {
        setState(() {
          _checklist[key] = value!;
        });
      },
    );
  }

  Future<void> _saveFormProgress({bool showMessage = true}) async {
    final l10n = AppLocalizations.of(context)!;
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> dataToSave = {
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'birthdate': _birthdateController.text,
      'model': _modelController.text,
      'hasCertificate': _hasCertificate,
      'hasManual': _hasManual,
      'checklist': _checklist,
      'improvements': _improvementsController.text,
    };
    await prefs.setString(_formProgressKey, jsonEncode(dataToSave));
    if (!mounted) return;
    if (showMessage) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.formSnackbarProgressSaved)),
      );
    } else {
      _notifyAutoSaved(l10n);
    }
  }

  void _notifyAutoSaved(AppLocalizations l10n) {
    if (_autosaveNotified) return;
    _autosaveNotified = true;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.formSnackbarProgressSaved)),
    );
  }

  void _scheduleAutoSave() {
    if (_isLoading) return;
    _autosaveTimer?.cancel();
    _autosaveTimer = Timer(const Duration(seconds: 1), () {
      _saveFormProgress(showMessage: false);
    });
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

  Widget _buildPreview() {
    final l10n = AppLocalizations.of(context)!;
    final inspectionData = _getInspectionData();
    final formattedData = _formatInspectionDataForDisplay(inspectionData, l10n);

    return AppSectionCard(
      title: l10n.formPreviewTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...formattedData.entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                onPressed: () {
                  setState(() {
                    _showPreview = false;
                  });
                },
                child: Text(l10n.formButtonBackToForm),
              ),
              ElevatedButton(
                onPressed: () => _sharePdfReport(context),
                child: Text(
                  l10n.formButtonSend,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getInspectionData() {
    final currentDate = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    return {
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'birthdate': _birthdateController.text,
      'model': _modelController.text,
      'hasCertificate': _hasCertificate,
      'hasManual': _hasManual,
      'checklist': _checklist,
      'improvements': _improvementsController.text,
      'date': currentDate,
      'type': 'Forklift',
    };
  }

  Map<String, String> _formatInspectionDataForDisplay(
      Map<String, dynamic> data, AppLocalizations l10n) {
    final formattedData = <String, String>{};
    formattedData[l10n.emailFieldDate] = data['date'] ?? '';
    formattedData[l10n.formFieldName] = data['name'] ?? '';
    formattedData[l10n.formFieldEmail] = data['email'] ?? '';
    formattedData[l10n.formFieldPhoneNumber] = data['phone'] ?? '';
    formattedData[l10n.formFieldBirthdate] = data['birthdate'] ?? '';
    formattedData[l10n.formFieldForkliftModel] = data['model'] ?? '';
    formattedData[l10n.emailFieldCertificate] =
        (data['hasCertificate'] as bool?) ?? false
            ? l10n.formAnswerYes
            : l10n.formAnswerNo;
    formattedData[l10n.emailFieldManual] = (data['hasManual'] as bool?) ?? false
        ? l10n.formAnswerYes
        : l10n.formAnswerNo;

    // Add checklist items
    final checklist = (data['checklist'] as Map<String, bool>?) ?? {};
    checklist.forEach((key, value) {
      final itemKey = key.replaceAll('_', '');
      final itemName = l10n.getString(
              'forkliftChecklistItem${itemKey.substring(4).capitalize()}') ??
          key;
      formattedData[itemName] = value
          ? l10n.emailChecklistItemStatusChecked
          : l10n.emailChecklistItemStatusUnchecked;
    });

    formattedData[l10n.formSectionImprovements] = data['improvements'] ?? '';
    return formattedData;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_showPreview) {
      return _buildPreview();
    }

    return Form(
      key: _formKey,
      onChanged: _scheduleAutoSave,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionCard(
            title: l10n.formSectionOperatorInfo,
            child: Column(children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: l10n.formFieldName),
                validator: (value) => value == null || value.isEmpty
                    ? l10n.formValidationNotEmpty
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: l10n.formFieldEmail),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.formValidationNotEmpty;
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return l10n.formValidationValidEmail;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                decoration:
                    InputDecoration(labelText: l10n.formFieldPhoneNumber),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _birthdateController,
                decoration: InputDecoration(labelText: l10n.formFieldBirthdate),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) => value == null || value.isEmpty
                    ? l10n.formValidationNotEmpty
                    : null,
              ),
            ]),
          ),
          AppSectionCard(
            title: l10n.formSectionForkliftInfo,
            child: TextFormField(
              controller: _modelController,
              decoration:
                  InputDecoration(labelText: l10n.formFieldForkliftModel),
              validator: (value) => value == null || value.isEmpty
                  ? l10n.formValidationNotEmpty
                  : null,
            ),
          ),
          AppSectionCard(
            title: l10n.formSectionDocumentation,
            child: Column(children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.formQuestionHasCertificate),
                value: _hasCertificate,
                onChanged: (bool value) =>
                    setState(() => _hasCertificate = value),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.formQuestionHasManual),
                value: _hasManual,
                onChanged: (bool value) => setState(() => _hasManual = value),
              ),
            ]),
          ),
          AppSectionCard(
            title: l10n.formSectionInspectionChecklist,
            child: Column(
              children: _checklist.keys.map((String key) {
                final itemNumber = key.split('_').last;
                final l10nKey =
                    'forkliftChecklistItem${itemNumber.capitalize()}';
                final String label = l10n.getString(l10nKey) ?? key;
                return _buildChecklistItem(label, key);
              }).toList(),
            ),
          ),
          AppSectionCard(
            title: l10n.formSectionImprovements,
            child: TextFormField(
              controller: _improvementsController,
              decoration: InputDecoration(
                labelText: l10n.formFieldImprovementsHint,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ),
          AppSectionCard(
            title: '',
            child: Column(
              children: [
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: _togglePreview,
                    child: Text(l10n.formButtonPreviewInspection,
                        style: const TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _saveFormProgress();
                      },
                      child: Text(l10n.formButtonSaveProgress),
                    ),
                    ElevatedButton(
                      onPressed: () => _confirmAndClearForm(),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent),
                      child: Text(l10n.formButtonClearForm,
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<Uint8List> _generateInspectionPdf(
      Map<String, dynamic> inspectionData, AppLocalizations l10n) async {
    final pdf = pw.Document();

    // Helper to add a text row
    pw.Widget buildPdfRow(String label, String? value) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(
                width: 150,
                child: pw.Text('$label:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
            pw.Expanded(child: pw.Text(value ?? l10n.formAnswerNotProvided)),
          ],
        ),
      );
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          List<pw.Widget> content = [
            pw.Header(
              level: 0,
              text: l10n.dailyCheckForkliftInspectionTitle,
              textStyle: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blueGrey800),
            ),
            buildPdfRow(l10n.emailFieldDate, inspectionData['date']),
            pw.SizedBox(height: 10),
            pw.Header(level: 1, text: l10n.formSectionOperatorInfo),
            buildPdfRow(l10n.formFieldName, inspectionData['name']),
            buildPdfRow(l10n.formFieldEmail, inspectionData['email']),
            buildPdfRow(l10n.formFieldPhoneNumber, inspectionData['phone']),
            buildPdfRow(l10n.formFieldBirthdate, inspectionData['birthdate']),
            pw.SizedBox(height: 10),
            pw.Header(level: 1, text: l10n.formSectionForkliftInfo),
            buildPdfRow(l10n.formFieldForkliftModel, inspectionData['model']),
            pw.SizedBox(height: 10),
            pw.Header(level: 1, text: l10n.formSectionDocumentation),
            buildPdfRow(
                l10n.emailFieldCertificate,
                (inspectionData['hasCertificate'] as bool? ?? false)
                    ? l10n.formAnswerYes
                    : l10n.formAnswerNo),
            buildPdfRow(
                l10n.emailFieldManual,
                (inspectionData['hasManual'] as bool? ?? false)
                    ? l10n.formAnswerYes
                    : l10n.formAnswerNo),
            pw.SizedBox(height: 10),
            pw.Header(level: 1, text: l10n.formSectionInspectionChecklist),
          ];

          final checklist =
              (inspectionData['checklist'] as Map<String, bool>?) ?? {};
          checklist.forEach((key, value) {
            final itemKey = key.replaceAll('_', '');
            final itemName = l10n.getString(
                    'forkliftChecklistItem${itemKey.substring(4).capitalize()}') ??
                key;
            content.add(buildPdfRow(
                itemName,
                value
                    ? l10n.emailChecklistItemStatusChecked
                    : l10n.emailChecklistItemStatusUnchecked));
          });

          content.addAll([
            pw.SizedBox(height: 10),
            pw.Header(level: 1, text: l10n.formSectionImprovements),
            pw.Paragraph(
                text: inspectionData['improvements'] ??
                    l10n.formAnswerNotProvided),
          ]);

          return content;
        },
      ),
    );
    return pdf.save();
  }

  Future<void> _sharePdfReport(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final inspectionData = _getInspectionData();
    final currentDate = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    String operatorName = inspectionData['name'] as String? ?? '';
    if (operatorName.isEmpty) {
      operatorName = 'UnknownOperator';
    }
    // Sanitize the operator name for the filename (replace spaces with underscores, remove invalid chars)
    final sanitizedOperatorName = operatorName
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'[^\w.-]'), '');
    final subject = l10n.emailSubjectForkliftInspection(currentDate);

    try {
      final Uint8List pdfBytes =
          await _generateInspectionPdf(inspectionData, l10n);
      final fileName =
          'Biks_AS_forklift_inspection_${sanitizedOperatorName}_${currentDate.replaceAll(":", "-")}.pdf';

      if (kIsWeb) {
        await pdf_download.downloadPdf(pdfBytes, fileName);
      } else {
        final file = await io_utils.writeTempFile(pdfBytes, fileName);
        if (!context.mounted) return;
        await SharePlus.instance.share(ShareParams(
            files: [XFile(file.path)],
            subject: subject,
            title: l10n.emailBodyPreamble,
            sharePositionOrigin: context.sharePositionOrigin));
      }

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.formSnackbarReportShared)),
      );
      await _clearSavedProgress();
      _clearForm();
    } catch (e) {
      debugPrint('Error sharing PDF report: $e');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(l10n.formSnackbarEmailFailed(
                e.toString()))), // Re-use or create a new l10n string
      );
    }
  }
}

// --- Machine Form Widget ---
class _MachineFormWidget extends StatefulWidget {
  const _MachineFormWidget();

  @override
  State<_MachineFormWidget> createState() => _MachineFormWidgetState();
}

class _MachineFormWidgetState extends State<_MachineFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _machineModelController = TextEditingController();
  final TextEditingController _machineIDController = TextEditingController();
  final TextEditingController _improvementsController = TextEditingController();

  static const String _formProgressKey = 'machine_form_progress';
  bool _hasCertificate = false;
  bool _hasManual = false;
  final Map<String, bool> _checklist = {};
  bool _isLoading = true;
  bool _showPreview = false;
  Timer? _autosaveTimer;
  bool _autosaveNotified = false;

  final List<String> _machineChecklistKeys = const [
    'machineChecklistItemVisualInspection',
    'machineChecklistItemFluidLevels',
    'machineChecklistItemHydraulicHoses',
    'machineChecklistItemTiresTracks',
    'machineChecklistItemBrakesSteering',
    'machineChecklistItemControlsEmergency',
    'machineChecklistItemWarningDevices',
    'machineChecklistItemAttachmentLock',
    'machineChecklistItemSafetyEquipment',
    'machineChecklistItemRops',
    'machineChecklistItemFireExtinguisher',
    'machineChecklistItemCleanliness',
    'machineChecklistItemDocumentationAvailable',
  ];

  @override
  void initState() {
    super.initState();
    for (final key in _machineChecklistKeys) {
      _checklist[key] = false;
    }
  }

  @override
  void dispose() {
    _autosaveTimer?.cancel();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthdateController.dispose();
    _machineModelController.dispose();
    _machineIDController.dispose();
    _improvementsController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadFormProgress());
      _isLoading = false;
    }
  }

  Future<void> _loadFormProgress() async {
    final l10n = AppLocalizations.of(context)!;
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final String? savedDataJson = prefs.getString(_formProgressKey);

    if (savedDataJson != null) {
      try {
        final Map<String, dynamic> savedData = jsonDecode(savedDataJson);
        setState(() {
          _nameController.text = savedData['name'] ?? '';
          _emailController.text = savedData['email'] ?? '';
          _phoneController.text = savedData['phone'] ?? '';
          _birthdateController.text = savedData['birthdate'] ?? '';
          if (savedData['birthdate'] != null &&
              savedData['birthdate'].isNotEmpty) {
            DateFormat('dd/MM/yyyy').parse(savedData['birthdate']);
          }
          _machineModelController.text = savedData['machineModel'] ?? '';
          _machineIDController.text = savedData['machineID'] ?? '';
          _hasCertificate = savedData['hasCertificate'] ?? false;
          _hasManual = savedData['hasManual'] ?? false;
          _improvementsController.text = savedData['improvements'] ?? '';
          if (savedData['checklist'] != null) {
            final Map<String, dynamic> cl = savedData['checklist'];
            cl.forEach((key, value) {
              if (_checklist.containsKey(key)) {
                _checklist[key] = value as bool;
              }
            });
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.formSnackbarProgressLoaded)),
        );
      } catch (e) {
        debugPrint("Error loading machine form progress: $e");
      }
    }
  }

  Future<void> _clearSavedProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_formProgressKey);
  }

  void _clearForm() {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _formKey.currentState?.reset();
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _birthdateController.clear();
      _machineModelController.clear();
      _machineIDController.clear();
      _hasCertificate = false;
      _hasManual = false;
      _improvementsController.clear();
      _checklist.updateAll((key, value) => false);
      _showPreview = false;
    });
    _clearSavedProgress();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.formSnackbarFormCleared)),
    );
  }

  Future<void> _confirmAndClearForm() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.formButtonClearForm),
        content: const Text('Er du sikker på at du vil tømme skjemaet?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l10n.cancel)),
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(l10n.formButtonClearForm)),
        ],
      ),
    );
    if (confirmed == true) {
      _clearForm();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthdateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Widget _buildChecklistItem(String label, String key) {
    return CheckboxListTile(
      title: Text(label, style: const TextStyle(fontSize: 15)),
      value: _checklist[key] ?? false,
      onChanged: (bool? value) {
        setState(() {
          _checklist[key] = value!;
        });
      },
      dense: true,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }

  Future<void> _saveFormProgress({bool showMessage = true}) async {
    final l10n = AppLocalizations.of(context)!;
    final prefs = await SharedPreferences.getInstance();
    final inspectionData = _getInspectionData();
    await prefs.setString(_formProgressKey, jsonEncode(inspectionData));
    if (!mounted) return;
    if (showMessage) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.formSnackbarProgressSaved)),
      );
    } else {
      _notifyAutoSaved(l10n);
    }
  }

  void _notifyAutoSaved(AppLocalizations l10n) {
    if (_autosaveNotified) return;
    _autosaveNotified = true;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.formSnackbarProgressSaved)),
    );
  }

  void _scheduleAutoSave() {
    if (_isLoading) return;
    _autosaveTimer?.cancel();
    _autosaveTimer = Timer(const Duration(seconds: 1), () {
      _saveFormProgress(showMessage: false);
    });
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

  Map<String, dynamic> _getInspectionData() {
    return {
      'date': DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'birthdate': _birthdateController.text,
      'machineModel': _machineModelController.text,
      'machineID': _machineIDController.text,
      'hasCertificate': _hasCertificate,
      'hasManual': _hasManual,
      'checklist': Map<String, bool>.from(_checklist),
      'improvements': _improvementsController.text,
    };
  }

  Map<String, String> _formatInspectionDataForDisplay(
      Map<String, dynamic> data, AppLocalizations l10n) {
    final formattedData = <String, String>{};
    formattedData[l10n.emailFieldDate] = data['date'] ?? '';
    formattedData[l10n.formFieldName] = data['name'] ?? '';
    formattedData[l10n.formFieldEmail] = data['email'] ?? '';
    formattedData[l10n.formFieldPhoneNumber] = data['phone'] ?? '';
    formattedData[l10n.formFieldBirthdate] = data['birthdate'] ?? '';
    formattedData[l10n.formFieldMachineModel] = data['machineModel'] ?? '';
    formattedData[l10n.formFieldMachineID] = data['machineID'] ?? '';
    formattedData[l10n.emailFieldCertificate] =
        data['hasCertificate'] == true ? l10n.formAnswerYes : l10n.formAnswerNo;
    formattedData[l10n.emailFieldManual] =
        data['hasManual'] == true ? l10n.formAnswerYes : l10n.formAnswerNo;

    final checklist = (data['checklist'] as Map<String, bool>?) ?? {};
    checklist.forEach((key, value) {
      final itemName = l10n.getString(key) ?? key;
      formattedData[itemName] =
          value ? l10n.emailChecklistItemStatusChecked : l10n.formAnswerNo;
    });

    formattedData[l10n.formSectionImprovements] =
        data['improvements'] ?? l10n.formAnswerNotProvided;
    return formattedData;
  }

  Widget _buildPreview() {
    final l10n = AppLocalizations.of(context)!;
    final inspectionData = _getInspectionData();
    final formattedData = _formatInspectionDataForDisplay(inspectionData, l10n);

    return AppSectionCard(
      title: l10n.dailyCheckMachineInspectionTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
      onChanged: _scheduleAutoSave,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionCard(
            title: l10n.formSectionOperatorInfo,
            child: Column(children: [
              TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: l10n.formFieldName),
                  validator: (value) => value == null || value.isEmpty
                      ? l10n.formValidationNotEmpty
                      : null),
              const SizedBox(height: 10),
              TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: l10n.formFieldEmail),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value == null || value.isEmpty
                      ? l10n.formValidationNotEmpty
                      : null),
              const SizedBox(height: 10),
              TextFormField(
                  controller: _phoneController,
                  decoration:
                      InputDecoration(labelText: l10n.formFieldPhoneNumber),
                  keyboardType: TextInputType.phone,
                  validator: (value) => value == null || value.isEmpty
                      ? l10n.formValidationNotEmpty
                      : null),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _birthdateController,
                    decoration:
                        InputDecoration(labelText: l10n.formFieldBirthdate),
                    validator: (value) => value == null || value.isEmpty
                        ? l10n.formValidationNotEmpty
                        : null,
                  ),
                ),
              ),
            ]),
          ),
          AppSectionCard(
            title: l10n.formSectionMachineInfo,
            child: Column(children: [
              TextFormField(
                  controller: _machineModelController,
                  decoration:
                      InputDecoration(labelText: l10n.formFieldMachineModel),
                  validator: (value) => value == null || value.isEmpty
                      ? l10n.formValidationNotEmpty
                      : null),
              const SizedBox(height: 10),
              TextFormField(
                  controller: _machineIDController,
                  decoration:
                      InputDecoration(labelText: l10n.formFieldMachineID),
                  validator: (value) => value == null || value.isEmpty
                      ? l10n.formValidationNotEmpty
                      : null),
            ]),
          ),
          AppSectionCard(
            title: l10n.formSectionDocumentation,
            child: Column(children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.formQuestionCertificateOfCompetence),
                value: _hasCertificate,
                onChanged: (bool value) {
                  setState(() {
                    _hasCertificate = value;
                  });
                },
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.formQuestionInstructionManualAvailable),
                value: _hasManual,
                onChanged: (bool value) {
                  setState(() {
                    _hasManual = value;
                  });
                },
              ),
            ]),
          ),
          AppSectionCard(
            title: l10n.formSectionInspectionChecklist,
            child: Column(
              children: _machineChecklistKeys.map((key) {
                final String localizedLabel = l10n.getString(key) ?? key;
                return _buildChecklistItem(localizedLabel, key);
              }).toList(),
            ),
          ),
          AppSectionCard(
            title: l10n.formSectionImprovements,
            child: TextFormField(
              controller: _improvementsController,
              decoration: InputDecoration(
                labelText: l10n.formFieldImprovementsHint,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ),
          AppSectionCard(
            title: '',
            child: Column(
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
                        onPressed: () {
                          _saveFormProgress();
                        },
                        child: Text(l10n.formButtonSaveProgress)),
                    ElevatedButton(
                        onPressed: () {
                          _confirmAndClearForm();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent),
                        child: Text(l10n.formButtonClearForm,
                            style: const TextStyle(color: Colors.white))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<Uint8List> _generateInspectionPdf(
      Map<String, dynamic> inspectionData, AppLocalizations l10n) async {
    final pdf = pw.Document();

    pw.Widget buildPdfRow(String label, String? value) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(
                width: 150,
                child: pw.Text('$label:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
            pw.Expanded(child: pw.Text(value ?? l10n.formAnswerNotProvided)),
          ],
        ),
      );
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          List<pw.Widget> content = [
            pw.Header(
              level: 0,
              text: l10n.dailyCheckMachineInspectionTitle,
              textStyle: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blueGrey800),
            ),
            buildPdfRow(l10n.emailFieldDate, inspectionData['date']),
            pw.SizedBox(height: 10),
            pw.Header(level: 1, text: l10n.formSectionOperatorInfo),
            buildPdfRow(l10n.formFieldName, inspectionData['name']),
            buildPdfRow(l10n.formFieldEmail, inspectionData['email']),
            buildPdfRow(l10n.formFieldPhoneNumber, inspectionData['phone']),
            buildPdfRow(l10n.formFieldBirthdate, inspectionData['birthdate']),
            pw.SizedBox(height: 10),
            pw.Header(level: 1, text: l10n.formSectionMachineInfo),
            buildPdfRow(
                l10n.formFieldMachineModel, inspectionData['machineModel']),
            buildPdfRow(l10n.formFieldMachineID, inspectionData['machineID']),
            pw.SizedBox(height: 10),
            pw.Header(level: 1, text: l10n.formSectionDocumentation),
            buildPdfRow(
                l10n.emailFieldCertificate,
                (inspectionData['hasCertificate'] as bool? ?? false)
                    ? l10n.formAnswerYes
                    : l10n.formAnswerNo),
            buildPdfRow(
                l10n.emailFieldManual,
                (inspectionData['hasManual'] as bool? ?? false)
                    ? l10n.formAnswerYes
                    : l10n.formAnswerNo),
            pw.SizedBox(height: 10),
            pw.Header(level: 1, text: l10n.formSectionInspectionChecklist),
          ];

          final checklist =
              (inspectionData['checklist'] as Map<String, bool>?) ?? {};
          checklist.forEach((key, value) {
            final itemName = l10n.getString(key) ?? key;
            content.add(buildPdfRow(
                itemName,
                value
                    ? l10n.emailChecklistItemStatusChecked
                    : l10n.emailChecklistItemStatusUnchecked));
          });

          content.addAll([
            pw.SizedBox(height: 10),
            pw.Header(level: 1, text: l10n.formSectionImprovements),
            pw.Paragraph(
                text: inspectionData['improvements'] ??
                    l10n.formAnswerNotProvided),
          ]);

          return content;
        },
      ),
    );
    return pdf.save();
  }

  Future<void> _sharePdfReport(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final inspectionData = _getInspectionData();
    final currentDate = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    String operatorName = inspectionData['name'] as String? ?? '';
    if (operatorName.isEmpty) {
      operatorName = 'UnknownOperator';
    }
    final sanitizedOperatorName = operatorName
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'[^\w.-]'), '');
    final subject = l10n.emailSubjectMachineInspection(currentDate);

    try {
      final Uint8List pdfBytes =
          await _generateInspectionPdf(inspectionData, l10n);
      final fileName =
          'Biks_AS_machine_inspection_${sanitizedOperatorName}_${currentDate.replaceAll(":", "-")}.pdf';

      if (kIsWeb) {
        await pdf_download.downloadPdf(pdfBytes, fileName);
      } else {
        final file = await io_utils.writeTempFile(pdfBytes, fileName);
        if (!context.mounted) return;
        await SharePlus.instance.share(ShareParams(
            files: [XFile(file.path)],
            subject: subject,
            title: l10n.emailBodyPreamble,
            sharePositionOrigin: context.sharePositionOrigin));
      }

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.formSnackbarReportShared)),
      );
      await _clearSavedProgress();
      _clearForm();
    } catch (e) {
      debugPrint('Error sharing PDF report: $e');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(l10n.formSnackbarEmailFailed(
                e.toString()))), // Re-use or create a new l10n string
      );
    }
  }
}

// --- Crane Form Widget ---
class _CraneFormWidget extends StatefulWidget {
  const _CraneFormWidget();
  @override
  State<_CraneFormWidget> createState() => _CraneFormWidgetState();
}

class _CraneFormWidgetState extends State<_CraneFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _operatorNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _craneModelController = TextEditingController();
  final TextEditingController _craneIDController = TextEditingController();
  final TextEditingController _improvementsController = TextEditingController();

  static const String _formProgressKey = 'crane_form_progress';
  bool _hasCertificate = false;
  bool _hasManual = false;
  final Map<String, bool> _checklist = {};
  bool _isLoading = true;
  bool _showPreview = false;
  Timer? _autosaveTimer;
  bool _autosaveNotified = false;

  final List<Map<String, String>> _genericCraneChecklistItems = [
    {
      'key': 'craneChecklistItemHoistTrolley',
      'label': 'Inspect Hoist/Trolley mechanisms'
    },
    {
      'key': 'craneChecklistItemRopesChains',
      'label': 'Check Wire Ropes/Chains for wear/damage'
    },
    {
      'key': 'craneChecklistItemLimitSwitches',
      'label': 'Test Upper and Lower Limit Switches'
    },
    {
      'key': 'craneChecklistItemLoadChart',
      'label': 'Verify Load Chart is visible and legible'
    },
    {
      'key': 'craneChecklistItemHooksLatches',
      'label': 'Inspect Hooks and Safety Latches'
    },
    {
      'key': 'craneChecklistItemOutriggers',
      'label': 'Check Outriggers/Stabilizers (if applicable)'
    },
    {
      'key': 'craneChecklistItemEmergencyStop',
      'label': 'Test Emergency Stop functionality'
    },
    {
      'key': 'craneChecklistItemControlSystem',
      'label': 'Inspect Control System (pendants, remotes)'
    },
    {
      'key': 'craneChecklistItemStructuralComponents',
      'label': 'Visual check of Structural Components (boom, jib)'
    },
    {
      'key': 'craneChecklistItemFluidLevels',
      'label': 'Check Fluid Levels (hydraulic, oil, coolant)'
    },
    {
      'key': 'craneChecklistItemSlewingMechanism',
      'label': 'Verify Slewing Ring/Mechanism'
    },
    {
      'key': 'craneChecklistItemBrakes',
      'label': 'Inspect Brakes (hoist, travel, slew)'
    },
    {
      'key': 'craneChecklistItemElectricalSystems',
      'label': 'Check Electrical Systems and Wiring'
    },
    {
      'key': 'craneChecklistItemWarningDevices',
      'label': 'Ensure Warning Devices (horn, lights) are functional'
    },
    {
      'key': 'craneChecklistItemLogsReview',
      'label': 'Review Maintenance and Inspection Logs'
    },
  ];

  @override
  void initState() {
    super.initState();
    for (var item in _genericCraneChecklistItems) {
      _checklist[item['key']!] = false;
    }
  }

  @override
  void dispose() {
    _autosaveTimer?.cancel();
    _operatorNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthdateController.dispose();
    _craneModelController.dispose();
    _craneIDController.dispose();
    _improvementsController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadFormProgress());
      _isLoading = false;
    }
  }

  Future<void> _loadFormProgress() async {
    final l10n = AppLocalizations.of(context)!;
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final String? savedDataJson = prefs.getString(_formProgressKey);

    if (savedDataJson != null) {
      try {
        final Map<String, dynamic> savedData = jsonDecode(savedDataJson);
        setState(() {
          _operatorNameController.text = savedData['operatorName'] ?? '';
          _emailController.text = savedData['email'] ?? '';
          _phoneController.text = savedData['phone'] ?? '';
          _birthdateController.text = savedData['birthdate'] ?? '';
          if (savedData['birthdate'] != null &&
              savedData['birthdate'].isNotEmpty) {
            DateFormat('dd/MM/yyyy').parse(savedData['birthdate']);
          }
          _craneModelController.text = savedData['craneModel'] ?? '';
          _craneIDController.text = savedData['craneID'] ?? '';
          _hasCertificate = savedData['hasCertificate'] ?? false;
          _hasManual = savedData['hasManual'] ?? false;
          _improvementsController.text = savedData['improvements'] ?? '';
          if (savedData['checklist'] != null) {
            Map<String, dynamic> cl = savedData['checklist'];
            cl.forEach((key, value) {
              if (_checklist.containsKey(key)) {
                _checklist[key] = value as bool;
              }
            });
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.formSnackbarProgressLoaded)),
        );
      } catch (e) {
        debugPrint("Error loading crane form progress: $e");
      }
    }
  }

  Future<void> _clearSavedProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_formProgressKey);
  }

  void _clearForm() {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _formKey.currentState?.reset();
      _operatorNameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _birthdateController.clear();
      _craneModelController.clear();
      _craneIDController.clear();
      _hasCertificate = false;
      _hasManual = false;
      _improvementsController.clear();
      _checklist.updateAll((key, value) => false);
      _showPreview = false;
    });
    _clearSavedProgress();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.formSnackbarFormCleared)),
    );
  }

  Future<void> _confirmAndClearForm() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.formButtonClearForm),
        content: const Text('Er du sikker på at du vil tømme skjemaet?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l10n.cancel)),
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(l10n.formButtonClearForm)),
        ],
      ),
    );
    if (confirmed == true) {
      _clearForm();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthdateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Widget _buildGenericCraneChecklistItem(String label, String key) {
    return CheckboxListTile(
      title: Text(label, style: const TextStyle(fontSize: 15)),
      value: _checklist[key] ?? false,
      onChanged: (bool? value) {
        setState(() {
          _checklist[key] = value!;
        });
      },
      dense: true,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }

  Future<void> _saveFormProgress({bool showMessage = true}) async {
    final l10n = AppLocalizations.of(context)!;
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> dataToSave = {
      'operatorName': _operatorNameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'birthdate': _birthdateController.text,
      'craneModel': _craneModelController.text,
      'craneID': _craneIDController.text,
      'hasCertificate': _hasCertificate,
      'hasManual': _hasManual,
      'checklist': _checklist,
      'improvements': _improvementsController.text,
    };
    await prefs.setString(_formProgressKey, jsonEncode(dataToSave));
    if (!mounted) return;
    if (showMessage) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.formSnackbarProgressSaved)),
      );
    } else {
      _notifyAutoSaved(l10n);
    }
  }

  void _notifyAutoSaved(AppLocalizations l10n) {
    if (_autosaveNotified) return;
    _autosaveNotified = true;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.formSnackbarProgressSaved)),
    );
  }

  void _scheduleAutoSave() {
    if (_isLoading) return;
    _autosaveTimer?.cancel();
    _autosaveTimer = Timer(const Duration(seconds: 1), () {
      _saveFormProgress(showMessage: false);
    });
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

  Widget _buildPreview() {
    final l10n = AppLocalizations.of(context)!;
    final inspectionData = _getInspectionData();
    final formattedData = _formatInspectionDataForDisplay(inspectionData, l10n);

    return AppSectionCard(
      title: l10n.formPreviewTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...formattedData.entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                onPressed: () {
                  setState(() {
                    _showPreview = false;
                  });
                },
                child: Text(l10n.formButtonBackToForm),
              ),
              ElevatedButton(
                onPressed: () => _sharePdfReport(context),
                child: Text(
                  l10n.formButtonSend,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getInspectionData() {
    final currentDate = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    return {
      'operatorName': _operatorNameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'birthdate': _birthdateController.text,
      'craneModel': _craneModelController.text,
      'craneID': _craneIDController.text,
      'hasCertificate': _hasCertificate,
      'hasManual': _hasManual,
      'checklist': _checklist,
      'improvements': _improvementsController.text,
      'date': currentDate,
      'type': 'Crane',
    };
  }

  Map<String, String> _formatInspectionDataForDisplay(
      Map<String, dynamic> data, AppLocalizations l10n) {
    final formattedData = <String, String>{};
    formattedData[l10n.emailFieldDate] = data['date'] ?? '';
    formattedData[l10n.formFieldOperatorName] = data['operatorName'] ?? '';
    formattedData[l10n.formFieldEmail] = data['email'] ?? '';
    formattedData[l10n.formFieldPhoneNumber] = data['phone'] ?? '';
    formattedData[l10n.formFieldBirthdate] = data['birthdate'] ?? '';
    formattedData[l10n.formFieldCraneModel] = data['craneModel'] ?? '';
    formattedData[l10n.formFieldCraneID] = data['craneID'] ?? '';
    formattedData[l10n.emailFieldCertificate] =
        (data['hasCertificate'] as bool?) ?? false
            ? l10n.formAnswerYes
            : l10n.formAnswerNo;
    formattedData[l10n.emailFieldManual] = (data['hasManual'] as bool?) ?? false
        ? l10n.formAnswerYes
        : l10n.formAnswerNo;

    // Add checklist items
    final checklist = (data['checklist'] as Map<String, bool>?) ?? {};
    checklist.forEach((key, value) {
      final itemName = l10n.getString(key) ?? key;
      formattedData[itemName] = value
          ? l10n.emailChecklistItemStatusChecked
          : l10n.emailChecklistItemStatusUnchecked;
    });

    formattedData[l10n.formSectionImprovements] = data['improvements'] ?? '';
    return formattedData;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_showPreview) {
      return _buildPreview();
    }

    return Form(
      key: _formKey,
      onChanged: _scheduleAutoSave,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionCard(
            title: l10n.formSectionOperatorInfo,
            child: Column(children: [
              TextFormField(
                controller: _operatorNameController,
                decoration:
                    InputDecoration(labelText: l10n.formFieldOperatorName),
                validator: (value) => value == null || value.isEmpty
                    ? l10n.formValidationNotEmpty
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: l10n.formFieldEmail),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.formValidationNotEmpty;
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return l10n.formValidationValidEmail;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                decoration:
                    InputDecoration(labelText: l10n.formFieldPhoneNumber),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _birthdateController,
                decoration: InputDecoration(labelText: l10n.formFieldBirthdate),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) => value == null || value.isEmpty
                    ? l10n.formValidationNotEmpty
                    : null,
              ),
            ]),
          ),
          AppSectionCard(
            title: l10n.formSectionCraneInfo,
            child: Column(children: [
              TextFormField(
                controller: _craneModelController,
                decoration:
                    InputDecoration(labelText: l10n.formFieldCraneModel),
                validator: (value) => value == null || value.isEmpty
                    ? l10n.formValidationNotEmpty
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _craneIDController,
                decoration: InputDecoration(labelText: l10n.formFieldCraneID),
                validator: (value) => value == null || value.isEmpty
                    ? l10n.formValidationNotEmpty
                    : null,
              ),
            ]),
          ),
          AppSectionCard(
            title: l10n.formSectionDocumentation,
            child: Column(children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.formQuestionHasCertificate),
                value: _hasCertificate,
                onChanged: (bool value) =>
                    setState(() => _hasCertificate = value),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.formQuestionHasManual),
                value: _hasManual,
                onChanged: (bool value) => setState(() => _hasManual = value),
              ),
            ]),
          ),
          AppSectionCard(
            title: l10n.formSectionInspectionChecklist,
            child: Column(
              children: [
                ..._genericCraneChecklistItems.map((item) {
                  final String itemKey = item['key']!;
                  final String localizedLabel = l10n.getString(itemKey) ??
                      item['label']!; // Use l10n.getString()
                  return _buildGenericCraneChecklistItem(
                      localizedLabel, itemKey);
                }),
              ],
            ),
          ),
          AppSectionCard(
            title: l10n.formSectionImprovements,
            child: TextFormField(
              controller: _improvementsController,
              decoration: InputDecoration(
                labelText: l10n.formFieldImprovementsHint,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ),
          AppSectionCard(
            title: '',
            child: Column(
              children: [
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      minimumSize:
                          const Size(double.infinity, 50), // Full width
                    ),
                    onPressed: _togglePreview,
                    child: Text(l10n.formButtonPreviewInspection,
                        style: const TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _saveFormProgress();
                      },
                      child: Text(l10n.formButtonSaveProgress),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _confirmAndClearForm();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent),
                      child: Text(l10n.formButtonClearForm,
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<Uint8List> _generateInspectionPdf(
      Map<String, dynamic> inspectionData, AppLocalizations l10n) async {
    final pdf = pw.Document();
    // final Map<String, String> displayData = _formatInspectionDataForDisplay(inspectionData, l10n);

    // Helper to add a text row
    pw.Widget buildPdfRow(String label, String? value) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(
                width: 150,
                child: pw.Text('$label:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
            pw.Expanded(child: pw.Text(value ?? l10n.formAnswerNotProvided)),
          ],
        ),
      );
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          List<pw.Widget> content = [
            pw.Header(
              level: 0,
              text: l10n.dailyCheckCraneInspectionTitle,
              textStyle: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blueGrey800),
            ),
            buildPdfRow(l10n.emailFieldDate, inspectionData['date']),
            pw.SizedBox(height: 10),
            pw.Header(level: 1, text: l10n.formSectionOperatorInfo),
            buildPdfRow(
                l10n.formFieldOperatorName, inspectionData['operatorName']),
            buildPdfRow(l10n.formFieldEmail, inspectionData['email']),
            buildPdfRow(l10n.formFieldPhoneNumber, inspectionData['phone']),
            buildPdfRow(l10n.formFieldBirthdate, inspectionData['birthdate']),
            pw.SizedBox(height: 10),
            pw.Header(level: 1, text: l10n.formSectionCraneInfo),
            buildPdfRow(l10n.formFieldCraneModel, inspectionData['craneModel']),
            buildPdfRow(l10n.formFieldCraneID, inspectionData['craneID']),
            pw.SizedBox(height: 10),
            pw.Header(level: 1, text: l10n.formSectionDocumentation),
            buildPdfRow(
                l10n.emailFieldCertificate,
                (inspectionData['hasCertificate'] as bool? ?? false)
                    ? l10n.formAnswerYes
                    : l10n.formAnswerNo),
            buildPdfRow(
                l10n.emailFieldManual,
                (inspectionData['hasManual'] as bool? ?? false)
                    ? l10n.formAnswerYes
                    : l10n.formAnswerNo),
            pw.SizedBox(height: 10),
            pw.Header(level: 1, text: l10n.formSectionInspectionChecklist),
          ];

          final checklist =
              (inspectionData['checklist'] as Map<String, bool>?) ?? {};
          checklist.forEach((key, value) {
            final itemName = l10n.getString(key) ?? key;
            content.add(buildPdfRow(
                itemName,
                value
                    ? l10n.emailChecklistItemStatusChecked
                    : l10n.emailChecklistItemStatusUnchecked));
          });

          content.addAll([
            pw.SizedBox(height: 10),
            pw.Header(level: 1, text: l10n.formSectionImprovements),
            pw.Paragraph(
                text: inspectionData['improvements'] ??
                    l10n.formAnswerNotProvided),
          ]);
          return content;
        },
      ),
    );
    return pdf.save();
  }

  Future<void> _sharePdfReport(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final inspectionData = _getInspectionData();
    final currentDate = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    String operatorName = inspectionData['operatorName'] as String? ?? '';
    // Sanitize the operator name for the filename
    if (operatorName.isEmpty) {
      operatorName = 'UnknownOperator';
    }
    final sanitizedOperatorName = operatorName
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'[^\w.-]'), '');
    final subject = l10n.emailSubjectCraneInspection(currentDate);

    try {
      final Uint8List pdfBytes =
          await _generateInspectionPdf(inspectionData, l10n);
      final fileName =
          'Biks_AS_crane_inspection_${sanitizedOperatorName}_${currentDate.replaceAll(":", "-")}.pdf';

      if (kIsWeb) {
        await pdf_download.downloadPdf(pdfBytes, fileName);
      } else {
        final file = await io_utils.writeTempFile(pdfBytes, fileName);
        if (!context.mounted) return;
        await SharePlus.instance.share(ShareParams(
            files: [XFile(file.path)],
            subject: subject,
            title: l10n.emailBodyPreamble,
            sharePositionOrigin: context.sharePositionOrigin));
      }

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(l10n
                .formSnackbarReportShared)), // You might want a specific l10n string here
      );
      await _clearSavedProgress();
      _clearForm();
    } catch (e) {
      debugPrint('Error sharing PDF report: $e');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(l10n.formSnackbarEmailFailed(
                e.toString()))), // Re-use or create a new l10n string
      );
    }
  }
}

extension AppLocalizationsExtension on AppLocalizations {
  String? getString(String key) {
    if (key == 'craneChecklistItemHoistTrolley') {
      return craneChecklistItemHoistTrolley;
    }
    if (key == 'craneChecklistItemRopesChains') {
      return craneChecklistItemRopesChains;
    }
    if (key == 'craneChecklistItemLimitSwitches') {
      return craneChecklistItemLimitSwitches;
    }
    if (key == 'craneChecklistItemLoadChart') {
      return craneChecklistItemLoadChart;
    }
    if (key == 'craneChecklistItemHooksLatches') {
      return craneChecklistItemHooksLatches;
    }
    if (key == 'craneChecklistItemOutriggers') {
      return craneChecklistItemOutriggers;
    }
    if (key == 'craneChecklistItemEmergencyStop') {
      return craneChecklistItemEmergencyStop;
    }
    if (key == 'craneChecklistItemControlSystem') {
      return craneChecklistItemControlSystem;
    }
    if (key == 'craneChecklistItemStructuralComponents') {
      return craneChecklistItemStructuralComponents;
    }
    if (key == 'craneChecklistItemFluidLevels') {
      return craneChecklistItemFluidLevels;
    }
    if (key == 'craneChecklistItemSlewingMechanism') {
      return craneChecklistItemSlewingMechanism;
    }
    if (key == 'craneChecklistItemBrakes') return craneChecklistItemBrakes;
    if (key == 'craneChecklistItemElectricalSystems') {
      return craneChecklistItemElectricalSystems;
    }
    if (key == 'craneChecklistItemWarningDevices') {
      return craneChecklistItemWarningDevices;
    }
    if (key == 'craneChecklistItemLogsReview') {
      return craneChecklistItemLogsReview;
    }

    // Machine items
    if (key == 'machineChecklistItemVisualInspection') {
      return machineChecklistItemVisualInspection;
    }
    if (key == 'machineChecklistItemFluidLevels') {
      return machineChecklistItemFluidLevels;
    }
    if (key == 'machineChecklistItemHydraulicHoses') {
      return machineChecklistItemHydraulicHoses;
    }
    if (key == 'machineChecklistItemTiresTracks') {
      return machineChecklistItemTiresTracks;
    }
    if (key == 'machineChecklistItemBrakesSteering') {
      return machineChecklistItemBrakesSteering;
    }
    if (key == 'machineChecklistItemControlsEmergency') {
      return machineChecklistItemControlsEmergency;
    }
    if (key == 'machineChecklistItemWarningDevices') {
      return machineChecklistItemWarningDevices;
    }
    if (key == 'machineChecklistItemAttachmentLock') {
      return machineChecklistItemAttachmentLock;
    }
    if (key == 'machineChecklistItemSafetyEquipment') {
      return machineChecklistItemSafetyEquipment;
    }
    if (key == 'machineChecklistItemRops') {
      return machineChecklistItemRops;
    }
    if (key == 'machineChecklistItemFireExtinguisher') {
      return machineChecklistItemFireExtinguisher;
    }
    if (key == 'machineChecklistItemCleanliness') {
      return machineChecklistItemCleanliness;
    }
    if (key == 'machineChecklistItemDocumentationAvailable') {
      return machineChecklistItemDocumentationAvailable;
    }

    // Forklift items
    if (key == 'forkliftChecklistItem5') return forkliftChecklistItem5;
    if (key == 'forkliftChecklistItem6') return forkliftChecklistItem6;
    if (key == 'forkliftChecklistItem7') return forkliftChecklistItem7;
    if (key == 'forkliftChecklistItem8') return forkliftChecklistItem8;
    if (key == 'forkliftChecklistItem9') return forkliftChecklistItem9;
    if (key == 'forkliftChecklistItem10') return forkliftChecklistItem10;
    if (key == 'forkliftChecklistItem11') return forkliftChecklistItem11;
    if (key == 'forkliftChecklistItem12') return forkliftChecklistItem12;
    if (key == 'forkliftChecklistItem13') return forkliftChecklistItem13;
    if (key == 'forkliftChecklistItem14') return forkliftChecklistItem14;
    if (key == 'forkliftChecklistItem15') return forkliftChecklistItem15;
    if (key == 'forkliftChecklistItem16') return forkliftChecklistItem16;
    if (key == 'forkliftChecklistItem17') return forkliftChecklistItem17;
    if (key == 'forkliftChecklistItem18') return forkliftChecklistItem18;
    if (key == 'forkliftChecklistItem19') return forkliftChecklistItem19;
    if (key == 'forkliftChecklistItem20') return forkliftChecklistItem20;
    if (key == 'forkliftChecklistItem21') return forkliftChecklistItem21;
    if (key == 'forkliftChecklistItem22') return forkliftChecklistItem22;
    return null;
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
