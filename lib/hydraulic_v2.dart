import 'package:biks/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:pdfx/pdfx.dart';

// --- Home Screen for the Hydraulic Calculator Feature ---
// Modernized with a GridView for a more engaging UI.
class HydraulicHomeScreen extends StatelessWidget {
  const HydraulicHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    // Fallback strings are used if l10n is null.
    final List<Map<String, dynamic>> calculators = [
      {
        'title': l10n?.cylinderCalculator ?? 'Cylinder Calculator',
        'icon': Icons.settings_applications_outlined,
        'page': const CylinderCalculatorPage(),
      },
      {
        'title': l10n?.motorCalculator ?? 'Motor Calculator',
        'icon': Icons.sync_alt,
        'page': const MotorPumpCalculatorPage(),
      },
      {
        'title': l10n?.pumpCalculator ?? 'Pump Calculator',
        'icon': Icons.water_damage_outlined,
        'page': const MotorPumpCalculatorPage(isPumpMode: true),
      },
      {
        'title': l10n?.pressureDropCalculator ?? 'Pressure Drop & Power',
        'icon': Icons.arrow_downward_outlined,
        'page': const PowerAndEfficiencyCalculatorPage(), // Renamed for clarity
      },
      {
        'title': l10n?.threadChart ?? 'Thread Chart',
        'icon': Icons.settings_input_component_outlined,
        'page': const ThreadChartPage(), // Renamed for consistency
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.hydraulicCalculator ?? 'Hydraulic Calculator'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: calculators.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          childAspectRatio: 1.1,
        ),
        itemBuilder: (context, index) {
          final category = calculators[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => category['page'] as Widget),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(category['icon'] as IconData,
                      size: 48, color: theme.colorScheme.primary),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      category['title'],
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// --- PDF Viewer Pages (G-Table & Thread Chart) ---
class GTablePage extends StatelessWidget {
  const GTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.gTable ?? 'G-Table'),
      ),
      body: PdfViewPinch(
        controller: PdfControllerPinch(
          document: PdfDocument.openAsset("lib/assets/g_table.pdf"),
        ),
      ),
    );
  }
}

class ThreadChartPage extends StatelessWidget {
  const ThreadChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.threadChart ?? 'Thread Chart'),
      ),
      body: PdfViewPinch(
        controller: PdfControllerPinch(
          document: PdfDocument.openAsset("lib/assets/gjengetabell.pdf"),
        ),
      ),
    );
  }
}

// --- Reusable Widgets (Modernized) ---
class _InputCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final IconData? titleIcon;

  const _InputCard(
      {required this.title, this.titleIcon, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (titleIcon != null) ...[
                  Icon(titleIcon, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                ],
                Text(title, style: theme.textTheme.titleLarge),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InputRow extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String unit;
  final IconData icon;

  const _InputRow({
    required this.controller,
    required this.label,
    required this.unit,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
              width: 60,
              child: Text(unit, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final String title;
  final List<Widget> results;
  final IconData titleIcon;

  const _ResultCard(
      {required this.title,
      required this.results,
      this.titleIcon = Icons.bar_chart});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.surfaceVariant,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(titleIcon, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(title, style: theme.textTheme.titleLarge),
              ],
            ),
            const Divider(height: 24),
            ...results,
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _ResultRow(
      {required this.label, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: theme.textTheme.bodyLarge)),
          Text("$value $unit",
              style: theme.textTheme.headlineSmall
                  ?.copyWith(color: theme.colorScheme.primary)),
        ],
      ),
    );
  }
}

// --- 1. Cylinder Calculator Page ---
class CylinderCalculatorPage extends StatefulWidget {
  const CylinderCalculatorPage({super.key});
  @override
  _CylinderCalculatorPageState createState() => _CylinderCalculatorPageState();
}

class _CylinderCalculatorPageState extends State<CylinderCalculatorPage> {
  final _boreDiaCtrl = TextEditingController();
  final _rodDiaCtrl = TextEditingController();
  final _pressureCtrl = TextEditingController();
  final _flowCtrl = TextEditingController();

  Map<String, double> results = {};

  @override
  void initState() {
    super.initState();
    final controllers = [_boreDiaCtrl, _rodDiaCtrl, _pressureCtrl, _flowCtrl];
    for (var ctrl in controllers) {
      ctrl.addListener(_calculate);
    }
  }

  @override
  void dispose() {
    final controllers = [_boreDiaCtrl, _rodDiaCtrl, _pressureCtrl, _flowCtrl];
    for (var ctrl in controllers) {
      ctrl.removeListener(_calculate);
      ctrl.dispose();
    }
    super.dispose();
  }

  void _calculate() {
    final boreDia = double.tryParse(_boreDiaCtrl.text) ?? 0;
    final rodDia = double.tryParse(_rodDiaCtrl.text) ?? 0;
    final pressure = double.tryParse(_pressureCtrl.text) ?? 0;
    final flow = double.tryParse(_flowCtrl.text) ?? 0;

    final boreRadiusCm = boreDia / 20.0;
    final rodRadiusCm = rodDia / 20.0;

    // FIX: Ensure all values are doubles by using .toDouble() after calculations like pow()
    final double boreArea = (pi * pow(boreRadiusCm, 2)).toDouble();
    final double rodArea = (boreArea - (pi * pow(rodRadiusCm, 2))).toDouble();
    final double validRodArea = rodArea > 0 ? rodArea : 0;

    setState(() {
      results = {
        'boreArea': boreArea,
        'rodArea': validRodArea,
        'boreForce': pressure * boreArea,
        'rodForce': pressure * validRodArea,
        'boreSpeed': boreArea > 0 ? flow / (6 * boreArea) : 0,
        'rodSpeed': validRodArea > 0 ? flow / (6 * validRodArea) : 0,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(l10n?.cylinderCalculator ?? 'Cylinder Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _InputCard(
              // FIX: Replaced l10n?.inputs which doesn't exist
              title: 'Inputs',
              titleIcon: Icons.edit_note,
              children: [
                _InputRow(
                    controller: _boreDiaCtrl,
                    label: l10n?.pistonBoreDiameter ?? 'Piston/Bore Diameter',
                    unit: "mm",
                    icon: Icons.fullscreen),
                _InputRow(
                    controller: _rodDiaCtrl,
                    label: l10n?.rodDiameter ?? 'Rod Diameter',
                    unit: "mm",
                    icon: Icons.linear_scale),
                _InputRow(
                    controller: _pressureCtrl,
                    label: l10n?.pressure ?? 'Pressure',
                    unit: "bar",
                    icon: Icons.speed),
                _InputRow(
                    controller: _flowCtrl,
                    label: l10n?.oilFlow ?? 'Oil Flow',
                    unit: "dm³/min",
                    icon: Icons.opacity),
              ],
            ),
            const SizedBox(height: 24),
            _ResultCard(
              title: l10n?.results ?? 'Results',
              results: [
                _ResultRow(
                    label: l10n?.boreSideArea ?? 'Bore Side Area',
                    value: (results['boreArea'] ?? 0).toStringAsFixed(2),
                    unit: "cm²"),
                _ResultRow(
                    label: l10n?.boreSideForce ?? 'Bore Side Force',
                    value: (results['boreForce'] ?? 0).toStringAsFixed(2),
                    unit: "kilo"),
                _ResultRow(
                    label: l10n?.rodSideArea ?? 'Rod Side Area',
                    value: (results['rodArea'] ?? 0).toStringAsFixed(2),
                    unit: "cm²"),
                _ResultRow(
                    label: l10n?.rodSideForce ?? 'Rod Side Force',
                    value: (results['rodForce'] ?? 0).toStringAsFixed(2),
                    unit: "kilo"),
                _ResultRow(
                    label: l10n?.boreSideVelocity ?? 'Bore Side Velocity',
                    value: (results['boreSpeed'] ?? 0).toStringAsFixed(2),
                    unit: "m/s"),
                _ResultRow(
                    label: l10n?.rodSideVelocity ?? 'Rod Side Velocity',
                    value: (results['rodSpeed'] ?? 0).toStringAsFixed(2),
                    unit: "m/s"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// --- 2. Motor & Pump Calculator Page ---
enum CalculationMode { torque, power, flow, speed }

class MotorPumpCalculatorPage extends StatefulWidget {
  final bool isPumpMode;
  const MotorPumpCalculatorPage({super.key, this.isPumpMode = false});

  @override
  _MotorPumpCalculatorPageState createState() =>
      _MotorPumpCalculatorPageState();
}

class _MotorPumpCalculatorPageState extends State<MotorPumpCalculatorPage> {
  late CalculationMode _mode;
  final _displacementCtrl = TextEditingController();
  final _pressureCtrl = TextEditingController();
  final _speedCtrl = TextEditingController();
  final _flowCtrl = TextEditingController();
  final _torqueCtrl = TextEditingController();
  final _powerCtrl = TextEditingController();
  String _resultValue = "0.00";

  @override
  void initState() {
    super.initState();
    _mode = widget.isPumpMode ? CalculationMode.flow : CalculationMode.torque;
    final controllers = [
      _displacementCtrl,
      _pressureCtrl,
      _speedCtrl,
      _flowCtrl,
      _torqueCtrl,
      _powerCtrl
    ];
    for (var ctrl in controllers) {
      ctrl.addListener(_calculate);
    }
  }

  @override
  void dispose() {
    final controllers = [
      _displacementCtrl,
      _pressureCtrl,
      _speedCtrl,
      _flowCtrl,
      _torqueCtrl,
      _powerCtrl
    ];
    for (var ctrl in controllers) {
      ctrl.removeListener(_calculate);
      ctrl.dispose();
    }
    super.dispose();
  }

  void _calculate() {
    final V = double.tryParse(_displacementCtrl.text) ?? 0;
    final p = double.tryParse(_pressureCtrl.text) ?? 0;
    final n = double.tryParse(_speedCtrl.text) ?? 0;
    final q = double.tryParse(_flowCtrl.text) ?? 0;

    double result = 0.0;
    switch (_mode) {
      case CalculationMode.torque:
        result = (V * p) / 63;
        break;
      case CalculationMode.power:
        result = (p * q) / 600;
        break;
      case CalculationMode.flow:
        result = (V * n) / 1000;
        break;
      case CalculationMode.speed:
        result = V > 0 ? (q * 1000) / V : 0;
        break;
    }
    if (mounted) {
      setState(() => _resultValue = result.toStringAsFixed(2));
    }
  }

  void _onModeChanged(CalculationMode? newValue) {
    if (newValue == null) return;
    setState(() {
      _mode = newValue;
      final controllers = [
        _displacementCtrl,
        _pressureCtrl,
        _speedCtrl,
        _flowCtrl,
        _torqueCtrl,
        _powerCtrl
      ];
      for (var ctrl in controllers) {
        ctrl.clear();
      }
      _resultValue = "0.00";
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pageTitle = widget.isPumpMode
        ? (l10n?.pumpCalculator ?? 'Pump Calculator')
        : (l10n?.motorCalculator ?? 'Motor Calculator');

    return Scaffold(
      appBar: AppBar(title: Text(pageTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildModeSelector(l10n),
            const SizedBox(height: 24),
            _InputCard(
              // FIX: Replaced l10n?.inputs which doesn't exist
              title: 'Inputs',
              titleIcon: Icons.edit_note,
              children: [_buildInputs(l10n)],
            ),
            const SizedBox(height: 24),
            _ResultCard(
              title: l10n?.results ?? 'Result',
              results: [_buildResult(l10n)],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSelector(AppLocalizations? l10n) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DropdownButtonFormField<CalculationMode>(
          value: _mode,
          decoration: InputDecoration(
            labelText: l10n?.calculate ?? 'Select Calculation',
            border: const OutlineInputBorder(),
          ),
          items: CalculationMode.values.map((mode) {
            return DropdownMenuItem(
              value: mode,
              child: Text(mode.toString().split('.').last.capitalize()),
            );
          }).toList(),
          onChanged: _onModeChanged,
        ),
      ),
    );
  }

  Widget _buildInputs(AppLocalizations? l10n) {
    switch (_mode) {
      case CalculationMode.torque:
        return Column(children: [
          _InputRow(
              controller: _displacementCtrl,
              label:
                  l10n?.volumeFlowCalculatorDisplacementLabel ?? 'Displacement',
              unit: "cm³/r",
              icon: Icons.open_in_full),
          _InputRow(
              controller: _pressureCtrl,
              label: l10n?.pressure ?? 'Pressure',
              unit: "bar",
              icon: Icons.speed),
        ]);
      case CalculationMode.power:
        return Column(children: [
          _InputRow(
              controller: _pressureCtrl,
              label: l10n?.pressure ?? 'Pressure',
              unit: "bar",
              icon: Icons.speed),
          _InputRow(
              controller: _flowCtrl,
              label: l10n?.volumeFlow ?? 'Volume Flow',
              unit: "dm³/min",
              icon: Icons.opacity),
        ]);
      case CalculationMode.flow:
        return Column(children: [
          _InputRow(
              controller: _displacementCtrl,
              label:
                  l10n?.volumeFlowCalculatorDisplacementLabel ?? 'Displacement',
              unit: "cm³/r",
              icon: Icons.open_in_full),
          _InputRow(
              controller: _speedCtrl,
              label: l10n?.volumeFlowCalculatorRpmLabel ?? 'Rotational Speed',
              unit: "r/min",
              icon: Icons.rotate_right),
        ]);
      case CalculationMode.speed:
        return Column(children: [
          _InputRow(
              controller: _flowCtrl,
              label: l10n?.volumeFlow ?? 'Volume Flow',
              unit: "dm³/min",
              icon: Icons.opacity),
          _InputRow(
              controller: _displacementCtrl,
              label:
                  l10n?.volumeFlowCalculatorDisplacementLabel ?? 'Displacement',
              unit: "cm³/r",
              icon: Icons.open_in_full),
        ]);
    }
  }

  Widget _buildResult(AppLocalizations? l10n) {
    switch (_mode) {
      case CalculationMode.torque:
        return _ResultRow(
            label: l10n?.torqueCalculatorResultLabel ?? 'Torque (M)',
            value: _resultValue,
            unit: "Nm");
      case CalculationMode.power:
        return _ResultRow(
            label: l10n?.hydraulicPowerCalculatorResultLabel ?? 'Power (P)',
            value: _resultValue,
            unit: "kW");
      case CalculationMode.flow:
        return _ResultRow(
            label: l10n?.volumeFlowCalculatorResultLabel ?? 'Volume Flow (q)',
            value: _resultValue,
            unit: "dm³/min");
      case CalculationMode.speed:
        return _ResultRow(
            label: l10n?.oilSpeedCalculatorResultLabel ?? 'Speed (v)',
            value: _resultValue,
            unit: "r/min");
    }
  }
}

// --- 3. Power & Efficiency Calculator Page ---
class PowerAndEfficiencyCalculatorPage extends StatefulWidget {
  const PowerAndEfficiencyCalculatorPage({super.key});

  @override
  _PowerAndEfficiencyCalculatorPageState createState() =>
      _PowerAndEfficiencyCalculatorPageState();
}

class _PowerAndEfficiencyCalculatorPageState
    extends State<PowerAndEfficiencyCalculatorPage> {
  final _pressureDropCtrl = TextEditingController();
  final _powerLossFlowCtrl = TextEditingController();
  double _powerLoss = 0.0;

  final _pInCtrl = TextEditingController();
  final _pOutCtrl = TextEditingController();
  double _efficiency = 0.0;

  @override
  void initState() {
    super.initState();
    _pressureDropCtrl.addListener(_calculatePowerLoss);
    _powerLossFlowCtrl.addListener(_calculatePowerLoss);
    _pInCtrl.addListener(_calculateEfficiency);
    _pOutCtrl.addListener(_calculateEfficiency);
  }

  @override
  void dispose() {
    _pressureDropCtrl.dispose();
    _powerLossFlowCtrl.dispose();
    _pInCtrl.dispose();
    _pOutCtrl.dispose();
    super.dispose();
  }

  void _calculatePowerLoss() {
    final delta_p = double.tryParse(_pressureDropCtrl.text) ?? 0;
    final q = double.tryParse(_powerLossFlowCtrl.text) ?? 0;
    setState(() => _powerLoss = (delta_p * q) / 600);
  }

  void _calculateEfficiency() {
    final p_in = double.tryParse(_pInCtrl.text) ?? 0;
    final p_out = double.tryParse(_pOutCtrl.text) ?? 0;
    setState(() => _efficiency = p_in > 0 ? (p_out / p_in) * 100 : 0);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(l10n?.pressureDropCalculator ?? 'Power & Efficiency')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _InputCard(
              title: l10n?.powerLossCalculatorTitle ?? 'Power Loss',
              titleIcon: Icons.bolt_outlined,
              children: [
                _InputRow(
                    controller: _pressureDropCtrl,
                    label: l10n?.pressureDrop ?? 'Pressure Drop',
                    unit: "bar",
                    icon: Icons.arrow_downward),
                _InputRow(
                    controller: _powerLossFlowCtrl,
                    label: l10n?.volumeFlow ?? 'Volume Flow',
                    unit: "dm³/min",
                    icon: Icons.opacity),
                const Divider(height: 20),
                _ResultRow(
                    label: l10n?.powerLoss ?? 'Power Loss',
                    value: _powerLoss.toStringAsFixed(2),
                    unit: "kW"),
              ],
            ),
            const SizedBox(height: 24),
            _InputCard(
              title: l10n?.efficiencyCalculatorTitle ?? 'Efficiency',
              titleIcon: Icons.percent_outlined,
              children: [
                _InputRow(
                    controller: _pInCtrl,
                    label: l10n?.efficiencyCalculatorInputPowerLabel ??
                        'Input Power (P.tilf)',
                    unit: "kW",
                    icon: Icons.input),
                _InputRow(
                    controller: _pOutCtrl,
                    label: l10n?.efficiencyCalculatorOutputPowerLabel ??
                        'Output Power (P.avg)',
                    unit: "kW",
                    icon: Icons.output),
                const Divider(height: 20),
                _ResultRow(
                    label: l10n?.efficiency ?? 'Efficiency (η)',
                    value: _efficiency.toStringAsFixed(1),
                    unit: "%"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Simple String extension for capitalizing first letter
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
