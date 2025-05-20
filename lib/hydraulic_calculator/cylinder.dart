import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CylinderCalculator extends StatefulWidget {
  const CylinderCalculator({super.key});

  @override
  _CylinderCalculatorState createState() => _CylinderCalculatorState();
}

class _CylinderCalculatorState extends State<CylinderCalculator> {
  final TextEditingController _pistonRadiusController = TextEditingController();
  final TextEditingController _rodRadiusController = TextEditingController();
  final TextEditingController _strokeLengthController = TextEditingController();
  final TextEditingController _pressureController = TextEditingController();
  final TextEditingController _flowRateController = TextEditingController();

  double _boreSideArea = 0;
  double _rodSideArea = 0;
  double _boreSideForce = 0;
  double _rodSideForce = 0;
  double _boreSideVelocity = 0;
  double _rodSideVelocity = 0;
  double _areaRatio = 0;

  void _calculate() {
    final pistonRadius = double.tryParse(_pistonRadiusController.text) ?? 0;
    final rodRadius = double.tryParse(_rodRadiusController.text) ?? 0;
    final strokeLength = double.tryParse(_strokeLengthController.text) ?? 0;
    final pressure = double.tryParse(_pressureController.text) ?? 0;
    final flowRate = double.tryParse(_flowRateController.text) ?? 0;

    setState(() {
      _boreSideArea = 3.1416 * pistonRadius * pistonRadius;
      _rodSideArea = _boreSideArea - (3.1416 * rodRadius * rodRadius);
      _boreSideForce = pressure * _boreSideArea;
      _rodSideForce = pressure * _rodSideArea;

      final boreSideVolume = _boreSideArea * strokeLength;
      final rodSideVolume = _rodSideArea * strokeLength;

      final boreSideTime = boreSideVolume / flowRate;
      final rodSideTime = rodSideVolume / flowRate;

      _boreSideVelocity = strokeLength / boreSideTime;
      _rodSideVelocity = strokeLength / rodSideTime;
      _areaRatio = _boreSideArea / _rodSideArea;
    });
  }

  void _reset() {
    _pistonRadiusController.clear();
    _rodRadiusController.clear();
    _strokeLengthController.clear();
    _pressureController.clear();
    _flowRateController.clear();
    setState(() {
      _boreSideArea = 0;
      _rodSideArea = 0;
      _boreSideForce = 0;
      _rodSideForce = 0;
      _boreSideVelocity = 0;
      _rodSideVelocity = 0;
      _areaRatio = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.cylinderCalculator)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _pistonRadiusController,
              decoration: InputDecoration(
                labelText: l10n.pistonRadius,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _rodRadiusController,
              decoration: InputDecoration(
                labelText: l10n.rodRadius,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _strokeLengthController,
              decoration: InputDecoration(
                labelText: l10n.strokeLength,
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
              controller: _flowRateController,
              decoration: InputDecoration(
                labelText: l10n.oilFlowRate,
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
                    _buildResultRow(l10n.boreSideArea,
                        '${_boreSideArea.toStringAsFixed(6)} m²'),
                    _buildResultRow(l10n.rodSideArea,
                        '${_rodSideArea.toStringAsFixed(6)} m²'),
                    _buildResultRow(l10n.boreSideForce,
                        '${_boreSideForce.toStringAsFixed(2)} N'),
                    _buildResultRow(l10n.rodSideForce,
                        '${_rodSideForce.toStringAsFixed(2)} N'),
                    _buildResultRow(l10n.boreSideVelocity,
                        '${_boreSideVelocity.toStringAsFixed(4)} m/s'),
                    _buildResultRow(l10n.rodSideVelocity,
                        '${_rodSideVelocity.toStringAsFixed(4)} m/s'),
                    _buildResultRow(
                        l10n.areaRatio, _areaRatio.toStringAsFixed(4)),
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
