import 'package:biks/hydraulic_calculator/cylinder.dart';
import 'package:biks/hydraulic_calculator/motor.dart';
import 'package:biks/hydraulic_calculator/piping.dart';
import 'package:biks/hydraulic_calculator/pressure_drop.dart';
import 'package:biks/hydraulic_calculator/pump.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HydraulicCalculator extends StatelessWidget {
  const HydraulicCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.hydraulicCalculator)),
      body: ListView(
        children: [
          ListTile(
            title: Text(l10n.cylinderCalculatorMenu),
            leading: Image.asset(
              'lib/assets/icons/cylinder.png', // Using your custom cylinder icon
              width: 24, // Standard icon size
              height: 24, // Standard icon size
              color: Theme.of(context).primaryColor, // Apply theme color
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CylinderCalculator()),
            ),
          ),
          // const Divider(height: 1), // Add a divider for separation
          ListTile(
            title: Text(l10n.pumpCalculatorMenu),
            leading: Image.asset(
              'lib/assets/icons/water-pump.png', // Using your custom cylinder icon
              width: 30, // Standard icon size
              height: 30, // Standard icon size
              color: Theme.of(context).primaryColor, // Apply theme color
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PumpCalculator()),
            ),
          ),
          // const Divider(height: 1), // Add a divider
          ListTile(
            title: Text(l10n.motorCalculatorMenu),
            leading: Image.asset(
              'lib/assets/icons/engine.png', // Using your custom cylinder icon
              width: 24, // Standard icon size
              height: 24, // Standard icon size
              color: Theme.of(context).primaryColor, // Apply theme color
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MotorCalculator()),
            ),
          ),
          // Add a divider
          ListTile(
            title: Text(l10n.pipingCalculatorMenu),
            leading: Image.asset(
              'lib/assets/icons/pipe.png', // Using your custom cylinder icon
              width: 24, // Standard icon size
              height: 24, // Standard icon size
              color: Theme.of(context).primaryColor, // Apply theme color
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PipingCalculator()),
            ),
          ),
          ListTile(
            title: Text(l10n.pressureDropCalculatorMenu),
            leading: Image.asset(
              'lib/assets/icons/pressure_drop.png', // Using your custom cylinder icon
              width: 24, // Standard icon size
              height: 24, // Standard icon size
              color: Theme.of(context).primaryColor, // Apply theme color
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PressureDropCalculator()),
            ),
          ),
        ],
      ),
    );
  }
}
