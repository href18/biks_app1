import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MotorCalculator extends StatefulWidget {
  const MotorCalculator({super.key});

  @override
  _MotorCalculatorState createState() => _MotorCalculatorState();
}

class _MotorCalculatorState extends State<MotorCalculator> {
  final TextEditingController _displacementController = TextEditingController();
  final TextEditingController _speedController = TextEditingController();
  final TextEditingController _volEfficiencyController =
      TextEditingController();
  final TextEditingController _powerController = TextEditingController();
  final TextEditingController _pressureController = TextEditingController();
  final TextEditingController _mechEfficiencyController =
      TextEditingController();

  double _flowRate = 0;
  int _calculationMode = 0; // 0 = displacement mode, 1 = power mode

  void _calculate() {
    if (_calculationMode == 0) {
      final displacement = double.tryParse(_displacementController.text) ?? 0;
      final speed = double.tryParse(_speedController.text) ?? 0;
      final volEfficiency = double.tryParse(_volEfficiencyController.text) ?? 0;

      setState(() {
        _flowRate = (displacement * speed) / (volEfficiency / 100);
      });
    } else {
      final power = double.tryParse(_powerController.text) ?? 0;
      final pressure = double.tryParse(_pressureController.text) ?? 0;
      final volEfficiency = double.tryParse(_volEfficiencyController.text) ?? 0;
      final mechEfficiency =
          double.tryParse(_mechEfficiencyController.text) ?? 0;

      setState(() {
        _flowRate =
            power / ((volEfficiency / 100) * (mechEfficiency / 100) * pressure);
      });
    }
  }

  void _reset() {
    _displacementController.clear();
    _speedController.clear();
    _volEfficiencyController.clear();
    _powerController.clear();
    _pressureController.clear();
    _mechEfficiencyController.clear();
    setState(() {
      _flowRate = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.motorCalculator)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SegmentedButton<int>(
              segments: [
                ButtonSegment(value: 0, label: Text(l10n.displacementMode)),
                ButtonSegment(value: 1, label: Text(l10n.powerMode)),
              ],
              selected: {_calculationMode},
              onSelectionChanged: (Set<int> newSelection) {
                setState(() {
                  _calculationMode = newSelection.first;
                });
              },
            ),
            const SizedBox(height: 20),
            if (_calculationMode == 0) ...[
              TextField(
                controller: _displacementController,
                decoration: InputDecoration(
                  labelText: l10n.displacement,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _speedController,
                decoration: InputDecoration(
                  labelText: l10n.speed,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ] else ...[
              TextField(
                controller: _powerController,
                decoration: InputDecoration(
                  labelText: l10n.power,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _pressureController,
                decoration: InputDecoration(
                  labelText: l10n.pressure,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _mechEfficiencyController,
                decoration: InputDecoration(
                  labelText: l10n.mechanicalEfficiency,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
            const SizedBox(height: 10),
            TextField(
              controller: _volEfficiencyController,
              decoration: InputDecoration(
                labelText: l10n.volumetricEfficiency,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _calculate,
                  child: Text(l10n.calculate),
                ),
                ElevatedButton(
                  onPressed: _reset,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: Text(l10n.reset),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(l10n.results,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const Divider(),
                    _buildResultRow(
                        l10n.flowRate, '${_flowRate.toStringAsFixed(6)} m³/s'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
