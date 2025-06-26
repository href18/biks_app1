import 'package:biks/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class PipingCalculator extends StatefulWidget {
  const PipingCalculator({super.key});

  @override
  _PipingCalculatorState createState() => _PipingCalculatorState();
}

class _PipingCalculatorState extends State<PipingCalculator> {
  final TextEditingController _pipeDiameterController = TextEditingController();
  final TextEditingController _flowRateController = TextEditingController();
  final TextEditingController _specificGravityController =
      TextEditingController();
  final TextEditingController _viscosityController = TextEditingController();

  double _crossSectionalArea = 0;
  double _velocity = 0;
  double _reynoldsNumber = 0;

  void _calculate() {
    final pipeDiameter = double.tryParse(_pipeDiameterController.text) ?? 0;
    final flowRate = double.tryParse(_flowRateController.text) ?? 0;
    final specificGravity =
        double.tryParse(_specificGravityController.text) ?? 0;
    final viscosity = double.tryParse(_viscosityController.text) ?? 0;

    setState(() {
      _crossSectionalArea = (3.1416 * pipeDiameter * pipeDiameter) / 4;
      _velocity = flowRate / _crossSectionalArea;
      _reynoldsNumber =
          (1000 * _velocity * pipeDiameter * specificGravity) / viscosity;
    });
  }

  void _reset() {
    _pipeDiameterController.clear();
    _flowRateController.clear();
    _specificGravityController.clear();
    _viscosityController.clear();
    setState(() {
      _crossSectionalArea = 0;
      _velocity = 0;
      _reynoldsNumber = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.pipingCalculator)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _pipeDiameterController,
              decoration: InputDecoration(
                labelText: l10n.pipeDiameter,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
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
              controller: _specificGravityController,
              decoration: InputDecoration(
                labelText: l10n.specificGravity,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _viscosityController,
              decoration: InputDecoration(
                labelText: l10n.absoluteViscosity,
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
                    _buildResultRow(l10n.crossSectionalArea,
                        '${_crossSectionalArea.toStringAsFixed(6)} m²'),
                    _buildResultRow(
                        l10n.velocity, '${_velocity.toStringAsFixed(4)} m/s'),
                    _buildResultRow(l10n.reynoldsNumber,
                        _reynoldsNumber.toStringAsFixed(2)),
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
