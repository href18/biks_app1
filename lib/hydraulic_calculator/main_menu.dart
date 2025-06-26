import 'package:biks/hydraulic_calculator/cylinder.dart';
import 'package:biks/hydraulic_calculator/motor.dart';
import 'package:biks/hydraulic_calculator/piping.dart';
import 'package:biks/hydraulic_calculator/pressure_drop.dart';
import 'package:biks/hydraulic_calculator/pump.dart';
import 'package:biks/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class HydraulicCalculator extends StatelessWidget {
  const HydraulicCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // A list of calculator items to easily manage them
    final calculatorItems = [
      {
        'title': l10n.cylinderCalculatorMenu,
        'icon': 'lib/assets/icons/cylinder.png',
        'route': const CylinderCalculator(),
      },
      {
        'title': l10n.pumpCalculatorMenu,
        'icon': 'lib/assets/icons/water-pump.png',
        'route': const PumpCalculator(),
      },
      {
        'title': l10n.motorCalculatorMenu,
        'icon': 'lib/assets/icons/engine.png',
        'route': const MotorCalculator(),
      },
      {
        'title': l10n.pipingCalculatorMenu,
        'icon': 'lib/assets/icons/pipe.png',
        'route': const PipingCalculator(),
      },
      {
        'title': l10n.pressureDropCalculatorMenu,
        'icon': 'lib/assets/icons/pressure_drop.png',
        'route': const PressureDropCalculator(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.hydraulicCalculator),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            crossAxisSpacing: 8.0, // Horizontal space between cards
            mainAxisSpacing: 8.0, // Vertical space between cards
            childAspectRatio: 1.2, // Aspect ratio of the cards
          ),
          itemCount: calculatorItems.length,
          itemBuilder: (context, index) {
            final item = calculatorItems[index];
            return Card(
              elevation: 4.0,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => item['route'] as Widget),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      item['icon'] as String,
                      width: 48,
                      height: 48,
                      color: theme.primaryColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      item['title'] as String,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
