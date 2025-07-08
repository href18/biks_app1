import 'package:biks/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Enum to represent the different measurement systems for clarity.
enum MeasurementSystem { dn, dash, inchesFraction, inchesDecimal, mm }

// A custom class to hold the data for each standard size.
class PipeSize {
  final String dn;
  final String inchesFraction;
  final double inchesDecimal;
  final double mm;
  final int dashSize;

  const PipeSize({
    required this.dn,
    required this.inchesFraction,
    required this.inchesDecimal,
    required this.mm,
    required this.dashSize,
  });

  // Helper method to get a value based on the selected system.
  String getValue(MeasurementSystem system) {
    switch (system) {
      case MeasurementSystem.dn:
        return dn;
      case MeasurementSystem.dash:
        return '-$dashSize';
      case MeasurementSystem.inchesFraction:
        return inchesFraction;
      case MeasurementSystem.inchesDecimal:
        return '$inchesDecimal"';
      case MeasurementSystem.mm:
        return '$mm mm';
    }
  }
}

// The core data for the conversion tool.
final List<PipeSize> pipeSizesData = [
  const PipeSize(
      dn: "DN 6",
      inchesFraction: "1/4\"",
      inchesDecimal: 0.25,
      mm: 6.35,
      dashSize: 4),
  const PipeSize(
      dn: "DN 8",
      inchesFraction: "5/16\"",
      inchesDecimal: 0.3125,
      mm: 7.94,
      dashSize: 5),
  const PipeSize(
      dn: "DN 10",
      inchesFraction: "3/8\"",
      inchesDecimal: 0.375,
      mm: 9.53,
      dashSize: 6),
  const PipeSize(
      dn: "DN 12",
      inchesFraction: "1/2\"",
      inchesDecimal: 0.5,
      mm: 12.7,
      dashSize: 8),
  const PipeSize(
      dn: "DN 16",
      inchesFraction: "5/8\"",
      inchesDecimal: 0.625,
      mm: 15.88,
      dashSize: 10),
  const PipeSize(
      dn: "DN 20",
      inchesFraction: "3/4\"",
      inchesDecimal: 0.75,
      mm: 19.05,
      dashSize: 12),
  const PipeSize(
      dn: "DN 25",
      inchesFraction: "1\"",
      inchesDecimal: 1.0,
      mm: 25.4,
      dashSize: 16),
  const PipeSize(
      dn: "DN 32",
      inchesFraction: "1 1/4\"",
      inchesDecimal: 1.25,
      mm: 31.75,
      dashSize: 20),
  const PipeSize(
      dn: "DN 38",
      inchesFraction: "1 1/2\"",
      inchesDecimal: 1.5,
      mm: 38.1,
      dashSize: 24),
  const PipeSize(
      dn: "DN 50",
      inchesFraction: "2\"",
      inchesDecimal: 2.0,
      mm: 50.8,
      dashSize: 32),
  const PipeSize(
      dn: "DN 63",
      inchesFraction: "2 1/2\"",
      inchesDecimal: 2.5,
      mm: 63.5,
      dashSize: 40),
  const PipeSize(
      dn: "DN 75",
      inchesFraction: "3\"",
      inchesDecimal: 3.0,
      mm: 76.2,
      dashSize: 48),
  const PipeSize(
      dn: "DN 100",
      inchesFraction: "4\"",
      inchesDecimal: 4.0,
      mm: 101.6,
      dashSize: 64),
];

// The root widget of the application
class ConversionToolApp extends StatelessWidget {
  const ConversionToolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('nb', ''),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blueAccent,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const ConverterHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// The main page of the converter tool, which is stateful
class ConverterHomePage extends StatefulWidget {
  const ConverterHomePage({super.key});

  @override
  State<ConverterHomePage> createState() => _ConverterHomePageState();
}

class _ConverterHomePageState extends State<ConverterHomePage> {
  PipeSize? _fromSize;
  MeasurementSystem? _toSystem;
  String _result = '';

  @override
  void initState() {
    super.initState();
    // Set initial default values
    _fromSize = pipeSizesData[2]; // Default to DN 10 / 3/8"
    _toSystem = MeasurementSystem.dash;
    _convert(); // Perform initial conversion
  }

  // Helper method to get the display name for a system from l10n.
  String _getSystemName(MeasurementSystem system, AppLocalizations l10n) {
    switch (system) {
      case MeasurementSystem.dn:
        return l10n.dnSystem;
      case MeasurementSystem.dash:
        return l10n.dashSystem;
      case MeasurementSystem.inchesFraction:
        return l10n.inchesFractionSystem;
      case MeasurementSystem.inchesDecimal:
        return l10n.inchesDecimalSystem;
      case MeasurementSystem.mm:
        return l10n.mmSystem;
    }
  }

  // Performs the conversion and updates the state.
  void _convert() {
    if (_fromSize == null || _toSystem == null) {
      setState(() {
        _result = '';
      });
      return;
    }
    setState(() {
      _result = _fromSize!.getValue(_toSystem!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.convertionTool),
        centerTitle: true,
        backgroundColor: theme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // "Convert From" Dropdown
                Text(l10n.convertFromLabel,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                _buildFromDropdown(),

                const SizedBox(height: 24),

                // "Convert To" Dropdown
                Text(l10n.convertToLabel,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                _buildToDropdown(l10n),

                const SizedBox(height: 32),

                // Result Display
                _buildResultDisplay(l10n),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Dropdown to select the initial value to convert from.
  Widget _buildFromDropdown() {
    return DropdownButtonFormField<PipeSize>(
      value: _fromSize,
      decoration: const InputDecoration(
        filled: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
      items: pipeSizesData.map((PipeSize size) {
        return DropdownMenuItem<PipeSize>(
          value: size,
          child: Text('${size.dn} / ${size.inchesFraction}'),
        );
      }).toList(),
      onChanged: (PipeSize? newValue) {
        setState(() {
          _fromSize = newValue;
          _convert();
        });
      },
    );
  }

  /// Dropdown to select the target measurement system.
  Widget _buildToDropdown(AppLocalizations l10n) {
    return DropdownButtonFormField<MeasurementSystem>(
      value: _toSystem,
      decoration: const InputDecoration(
        filled: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
      items: MeasurementSystem.values.map((MeasurementSystem system) {
        return DropdownMenuItem<MeasurementSystem>(
          value: system,
          child: Text(_getSystemName(system, l10n)),
        );
      }).toList(),
      onChanged: (MeasurementSystem? newValue) {
        setState(() {
          _toSystem = newValue;
          _convert();
        });
      },
    );
  }

  /// Displays the conversion result in a styled card.
  Widget _buildResultDisplay(AppLocalizations l10n) {
    // Get the name of the target system, if one is selected
    final String systemName =
        _toSystem != null ? _getSystemName(_toSystem!, l10n) : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.resultLabel, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: Card(
            elevation: 0,
            color:
                Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                // Use a Column to stack the value and its unit/system name.
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // The main result value
                    Text(
                      _result,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    // The unit/system name below it
                    if (systemName.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        systemName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.7),
                            ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
