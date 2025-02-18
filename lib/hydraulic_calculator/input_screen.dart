import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HydraKalk extends StatefulWidget {
  @override
  _HydraKalkState createState() => _HydraKalkState();
}

class _HydraKalkState extends State<HydraKalk> {
  // Input fields
  double pistonDiameter = 0;
  double rodDiameter = 0;
  double strokeLength = 0;
  double pressure = 0;
  double oilFlowRate = 0;

  // Units
  String pistonDiameterUnit = 'mm';
  String rodDiameterUnit = 'mm';
  String strokeLengthUnit = 'mm';
  String pressureUnit = 'bar';
  String oilFlowRateUnit = 'lpm';

  // Calculated values
  double boreSideArea = 0;
  double rodSideArea = 0;
  double boreSideVolume = 0;
  double rodSideVolume = 0;
  double boreSideForce = 0;
  double rodSideForce = 0;
  double time = 0;
  double velocity = 0;
  double outflow = 0;
  double ratio = 0;

  void calculateValues() {
    double radiusPiston =
        convertToCentimeters(pistonDiameter, pistonDiameterUnit) / 2;
    double radiusRod = convertToCentimeters(rodDiameter, rodDiameterUnit) / 2;
    double strokeCentimeters =
        convertToCentimeters(strokeLength, strokeLengthUnit);

    boreSideArea = 3.14159 * radiusPiston * radiusPiston;
    rodSideArea = 3.14159 * radiusRod * radiusRod;

    boreSideVolume =
        boreSideArea * strokeCentimeters / 1000; // Convert cm³ to liters
    rodSideVolume =
        rodSideArea * strokeCentimeters / 1000; // Convert cm³ to liters

    double pressurePascals = convertToPascals(pressure, pressureUnit);
    boreSideForce = (pressurePascals * boreSideArea) / 10; // Convert N to kN
    rodSideForce = (pressurePascals * rodSideArea) / 10; // Convert N to kN

    double flowRateLitersPerSecond =
        convertToLitersPerSecond(oilFlowRate, oilFlowRateUnit);
    time = boreSideVolume / flowRateLitersPerSecond;
    velocity = strokeCentimeters / time / 100; // Convert cm/s to m/s
    ratio = boreSideArea / rodSideArea;
    outflow = oilFlowRate * ratio;

    setState(() {});
  }

  double convertToCentimeters(double value, String unit) {
    switch (unit) {
      case 'mm':
        return value / 10;
      case 'cm':
        return value;
      case 'm':
        return value * 100;
      default:
        return value;
    }
  }

  double convertToPascals(double value, String unit) {
    switch (unit) {
      case 'bar':
        return value * 100000;
      case 'MPa':
        return value * 1000000;
      case 'P':
        return value;
      default:
        return value;
    }
  }

  double convertToLitersPerSecond(double value, String unit) {
    switch (unit) {
      case 'lpm':
        return value / 60;
      case 'm³/min':
        return value * 1000 / 60;
      case 'cm³/min':
        return value / 60000;
      default:
        return value;
    }
  }

  void resetValues() {
    setState(() {
      pistonDiameter = 0;
      rodDiameter = 0;
      strokeLength = 0;
      pressure = 0;
      oilFlowRate = 0;
      boreSideArea = 0;
      rodSideArea = 0;
      boreSideVolume = 0;
      rodSideVolume = 0;
      boreSideForce = 0;
      rodSideForce = 0;
      time = 0;
      velocity = 0;
      outflow = 0;
      ratio = 0;
    });
  }

  void copyToClipboard() {
    String results = '''
Bore Side Area: ${boreSideArea.toStringAsFixed(2)} cm²
Rod Side Area: ${rodSideArea.toStringAsFixed(2)} cm²
Bore Side Volume: ${boreSideVolume.toStringAsFixed(2)} l
Rod Side Volume: ${rodSideVolume.toStringAsFixed(2)} l
Bore Side Force: ${boreSideForce.toStringAsFixed(2)} kN
Rod Side Force: ${rodSideForce.toStringAsFixed(2)} kN
Time: ${time.toStringAsFixed(2)} sec
Velocity: ${velocity.toStringAsFixed(2)} m/s
Outflow: ${outflow.toStringAsFixed(2)} lpm
Ratio: ${ratio.toStringAsFixed(2)}
''';
    Clipboard.setData(ClipboardData(text: results));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Results copied to clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cylinder Calculator'),
        actions: [
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: copyToClipboard,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: resetValues,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildSection('Cylinder Parameters', [
                _buildInputField('Piston/Bore Diameter', pistonDiameterUnit,
                    (value) {
                  pistonDiameter = double.tryParse(value) ?? 0;
                  calculateValues();
                }, ['mm', 'cm', 'm']),
                _buildInputField('Rod Diameter', rodDiameterUnit, (value) {
                  rodDiameter = double.tryParse(value) ?? 0;
                  calculateValues();
                }, ['mm', 'cm', 'm']),
                _buildInputField('Stroke', strokeLengthUnit, (value) {
                  strokeLength = double.tryParse(value) ?? 0;
                  calculateValues();
                }, ['mm', 'cm', 'm']),
                _buildInputField('Pressure', pressureUnit, (value) {
                  pressure = double.tryParse(value) ?? 0;
                  calculateValues();
                }, ['bar', 'MPa', 'P']),
                _buildInputField('Oil Flow', oilFlowRateUnit, (value) {
                  oilFlowRate = double.tryParse(value) ?? 0;
                  calculateValues();
                }, ['lpm', 'm³/min', 'cm³/min']),
              ]),
              SizedBox(height: 20),
              _buildSection('Bore Side', [
                _buildResultField(
                    'Area (cm²)', boreSideArea.toStringAsFixed(2)),
                _buildResultField(
                    'Volume (l)', boreSideVolume.toStringAsFixed(2)),
                _buildResultField(
                    'Force (kN)', boreSideForce.toStringAsFixed(2)),
              ]),
              SizedBox(height: 20),
              _buildSection('Rod Side', [
                _buildResultField('Area (cm²)', rodSideArea.toStringAsFixed(2)),
                _buildResultField(
                    'Volume (l)', rodSideVolume.toStringAsFixed(2)),
                _buildResultField(
                    'Force (kN)', rodSideForce.toStringAsFixed(2)),
              ]),
              SizedBox(height: 20),
              _buildSection('Additional Results', [
                _buildResultField('Time (sec)', time.toStringAsFixed(2)),
                _buildResultField(
                    'Velocity (m/s)', velocity.toStringAsFixed(2)),
                _buildResultField('Outflow (lpm)', outflow.toStringAsFixed(2)),
                _buildResultField('Ratio', ratio.toStringAsFixed(2)),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        ...children,
      ],
    );
  }

  Widget _buildInputField(String label, String unit, Function(String) onChanged,
      List<String> units) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          decoration: InputDecoration(labelText: '$label ($unit)'),
          keyboardType: TextInputType.number,
          onChanged: onChanged,
        ),
        SizedBox(height: 8),
        ToggleButtons(
          isSelected: units.map((u) => u == unit).toList(),
          onPressed: (index) {
            setState(() {
              if (label == 'Piston/Bore Diameter')
                pistonDiameterUnit = units[index];
              if (label == 'Rod Diameter') rodDiameterUnit = units[index];
              if (label == 'Stroke') strokeLengthUnit = units[index];
              if (label == 'Pressure') pressureUnit = units[index];
              if (label == 'Oil Flow') oilFlowRateUnit = units[index];
              calculateValues();
            });
          },
          children: units.map((u) => Text(u)).toList(),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildResultField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value),
        ],
      ),
    );
  }
}
