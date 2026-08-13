import 'package:biks/hydraulic_v2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('cylinder forces are calculated and displayed in newtons',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: CylinderCalculatorPage()),
    );

    final inputs = find.byType(TextField);
    expect(inputs, findsNWidgets(4));

    await tester.enterText(inputs.at(0), '100');
    await tester.enterText(inputs.at(1), '50');
    await tester.enterText(inputs.at(2), '100');
    await tester.enterText(inputs.at(3), '10');
    await tester.pump();

    expect(find.text('78539.82 N'), findsOneWidget);
    expect(find.text('58904.86 N'), findsOneWidget);
    expect(find.textContaining('kgf'), findsNothing);
  });
}
