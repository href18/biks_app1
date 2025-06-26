import 'package:biks/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class PressureDropCalculator extends StatefulWidget {
  const PressureDropCalculator({super.key});

  @override
  _PressureDropCalculatorState createState() => _PressureDropCalculatorState();
}

class _PressureDropCalculatorState extends State<PressureDropCalculator> {
  final TextEditingController _flowRateController = TextEditingController();
  final TextEditingController _orificeCoefficientController =
      TextEditingController();
  final TextEditingController _diameterController = TextEditingController();
  final TextEditingController _specificGravityController =
      TextEditingController();

  double _pressureDrop = 0;

  void _calculate() {
    final flowRate = double.tryParse(_flowRateController.text) ?? 0;
    final orificeCoefficient =
        double.tryParse(_orificeCoefficientController.text) ?? 0;
    final diameter = double.tryParse(_diameterController.text) ?? 0;
    final specificGravity =
        double.tryParse(_specificGravityController.text) ?? 0;

    setState(() {
      final denominator =
          0.021275 * 3.1416 * orificeCoefficient * diameter * diameter;
      _pressureDrop =
          (flowRate / denominator) * (flowRate / denominator) * specificGravity;
    });
  }

  void _reset() {
    _flowRateController.clear();
    _orificeCoefficientController.clear();
    _diameterController.clear();
    _specificGravityController.clear();
    setState(() {
      _pressureDrop = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.pressureDropCalculator)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _flowRateController,
              decoration: InputDecoration(
                labelText: l10n.flowRate,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _orificeCoefficientController,
              decoration: InputDecoration(
                labelText: l10n.orificeCoefficient,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _diameterController,
              decoration: InputDecoration(
                labelText: l10n.pipeDiameter,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _specificGravityController,
              decoration: InputDecoration(
                labelText: l10n.specificGravity,
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
                    _buildResultRow(l10n.pressureDrop,
                        '${_pressureDrop.toStringAsFixed(2)} Pa'),
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
