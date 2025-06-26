import 'dart:io';
import 'dart:typed_data';
import 'package:biks/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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
  final TextEditingController _truckNumberController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime _trainingDate = DateTime.now();
  String? _selectedTruckType;
  String? _selectedTruckModel;
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

  final Map<int, String?> _selectedOptions = {};
  final Map<int, String> _additionalNotes = {};

  bool _showPreview = false;

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
    _truckNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _traineeNameController.clear();
    _trainerNameController.clear();
    _companyController.clear();
    _truckNumberController.clear();
    _notesController.clear();
    setState(() {
      _trainingDate = DateTime.now();
      _selectedTruckType = null;
      _selectedOptions.clear();
      _additionalNotes.clear();
      _showPreview = false; // Go back to form view
    });
    final l10n = AppLocalizations.of(context)!;
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
      'formSubHeader': l10n.forkliftTypeTrainingHeader,
      'regulationsSubHeader': l10n.regulationsSubHeader,
      'traineeName': _traineeNameController.text,
      'trainerName': _trainerNameController.text,
      'company': _companyController.text,
      'truckType': _selectedTruckType,
      'truckNumber': _truckNumberController.text,
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
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.formPreviewTitle,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary)),
            const SizedBox(height: 16),
            _buildPreviewRow(
                l10n.dateGeneratedLabel, formData['dateGenerated'] as String?),
            _buildPreviewRow(
                l10n.trainingDateLabel, formData['trainingDate'] as String?),
            _buildPreviewRow(
                l10n.truckTypeLabel, formData['truckType'] as String?),
            _buildPreviewRow(
                l10n.truckNumberLabel, formData['truckNumber'] as String?),
            _buildPreviewRow(
                l10n.trainerNameLabel, formData['trainerName'] as String?),
            _buildPreviewRow(
                l10n.traineeNameLabel, formData['traineeName'] as String?),
            _buildPreviewRow(l10n.companyLabel, formData['company'] as String?),
            const SizedBox(height: 16),
            Text(l10n.trainingChecklistSection,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...(formData['checklist'] as List<dynamic>).map((item) {
              final question = item['question'] as String;
              final selectedOption = item['selectedOption'] as String?;
              final additionalNote = item['additionalNote'] as String?;
              String displayValue =
                  selectedOption ?? l10n.formAnswerNotSelected;
              if (additionalNote != null && additionalNote.isNotEmpty) {
                displayValue +=
                    ' (${l10n.commentsReasonLabel}: $additionalNote)';
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
                  onPressed: _sharePdfReport,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary),
                  child: Text(l10n.formButtonSend)),
            ]),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (!_checklistInitialized) {
      _checklistItems = [
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
      _checklistInitialized = true;
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
                  // Header with regulation reference
                  Text(
                    l10n.forkliftTypeTrainingHeader,
                    style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.regulationsSubHeader,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(fontStyle: FontStyle.italic),
                  ),
                  Divider(
                      height: 30,
                      color: theme.dividerColor.withAlpha((0.5 * 255).round())),

                  // Training information section
                  Text(
                    l10n.trainingInformationSection,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(color: theme.colorScheme.primary),
                  ),
                  const SizedBox(height: 10),

                  // Truck information
                  DropdownButtonFormField<String>(
                    value: _selectedTruckType,
                    decoration: InputDecoration(
                      labelText: l10n.truckTypeLabel,
                      // Uses theme's InputDecorationTheme
                    ),
                    items: _truckTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTruckType = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? l10n.requiredFieldValidator : null,
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _truckNumberController,
                    decoration: InputDecoration(
                      labelText: l10n.truckNumberLabel,
                    ),
                    validator: (value) => value?.isEmpty ?? true
                        ? l10n.requiredFieldValidator
                        : null,
                  ),
                  const SizedBox(height: 10),

                  // Trainer and trainee information
                  TextFormField(
                    controller: _trainerNameController,
                    decoration: InputDecoration(
                      labelText: l10n.trainerNameLabel,
                    ),
                    validator: (value) => value?.isEmpty ?? true
                        ? l10n.requiredFieldValidator
                        : null,
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _traineeNameController,
                    decoration: InputDecoration(
                      labelText: l10n.traineeNameLabel,
                    ),
                    validator: (value) => value?.isEmpty ?? true
                        ? l10n.requiredFieldValidator
                        : null,
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _companyController,
                    decoration: InputDecoration(
                      labelText: l10n.companyLabel,
                    ),
                    validator: (value) => value?.isEmpty ?? true
                        ? l10n.requiredFieldValidator
                        : null,
                  ),
                  const SizedBox(height: 10),

                  // Date selection
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
                  Divider(
                      height: 30,
                      color: theme.dividerColor.withAlpha((0.5 * 255).round())),

                  // Checklist section
                  Text(
                    l10n.trainingChecklistSection,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(color: theme.colorScheme.primary),
                  ),
                  const SizedBox(height: 10),
                  ..._checklistItems.asMap().entries.map((entry) {
                    int index = entry.key;
                    ChecklistItem item = entry.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.question,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 5),

                        // Render different input types based on options
                        if (item.options.length == 1)
                          CheckboxListTile(
                            title: Text(item.options[0]),
                            value: _selectedOptions[index] == item.options[0],
                            onChanged: (bool? value) {
                              FocusScope.of(context)
                                  .unfocus(); // Dismiss keyboard
                              setState(() {
                                _selectedOptions[index] =
                                    value == true ? item.options[0] : null;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
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
                  }),

                  // General notes
                  const SizedBox(height: 20),
                  Text(
                    l10n.additionalNotesSection,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: l10n.additionalNotesHint,
                    ),
                  ),

                  // Submit button
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: _togglePreview, // Changed from _submitForm
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(l10n
                          .formButtonPreviewReport), // Ensure this l10n key exists
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
  final pdf = pw.Document();

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
          buildPdfRow(l10n.truckTypeLabel, formData['truckType'] as String?),
          buildPdfRow(
              l10n.truckNumberLabel, formData['truckNumber'] as String?),
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
      final fileName =
          'Typekontroll_${formData['truckType']?.replaceAll('.', '') ?? "rapport"}_${formData['traineeName']?.replaceAll(" ", "_") ?? "kursdeltaker"}_${DateFormat('yyyyMMdd').format(trainingDate)}.pdf';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(pdfBytes);

      await SharePlus.instance.share(ShareParams(
          files: [XFile(file.path)],
          subject: subject,
          title: l10n.emailBodyPreamble));
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.formSnackbarReportShared)));
      _clearForm();
    } catch (e) {
      print('Error sharing PDF report for Type Control: $e');
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
