import 'package:biks/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class PumpCalculator extends StatefulWidget {
  const PumpCalculator({super.key});

  @override
  _PumpCalculatorState createState() => _PumpCalculatorState();
}

class _PumpCalculatorState extends State<PumpCalculator> {
  final TextEditingController _displacementController = TextEditingController();
  final TextEditingController _speedController = TextEditingController();
  final TextEditingController _efficiencyController = TextEditingController();

  double _flowRate = 0;

  void _calculate() {
    final displacement = double.tryParse(_displacementController.text) ?? 0;
    final speed = double.tryParse(_speedController.text) ?? 0;
    final efficiency = double.tryParse(_efficiencyController.text) ?? 0;

    setState(() {
      _flowRate = displacement * speed * (efficiency / 100);
    });
  }

  void _reset() {
    _displacementController.clear();
    _speedController.clear();
    _efficiencyController.clear();
    setState(() {
      _flowRate = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.pumpCalculator)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
            const SizedBox(height: 10),
            TextField(
              controller: _efficiencyController,
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
