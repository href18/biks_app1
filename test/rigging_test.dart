import 'package:biks/views/rigging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows rigging documents grouped by equipment type',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: RiggingScreen()),
    );

    expect(find.text('Rigging'), findsOneWidget);
    expect(find.text('Eagleclamp'), findsOneWidget);
    expect(find.text('Kjettingløkke'), findsOneWidget);
    expect(find.text('HEA-profil'), findsOneWidget);
    expect(find.text('5 profiler'), findsOneWidget);

    await tester.tap(find.text('Eagleclamp'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kjettingløkke'));
    await tester.pumpAndSettle();

    expect(find.text('RHS-profil'), findsOneWidget);
    expect(find.text('UNP-profil'), findsOneWidget);

    await tester.tap(find.text('Kjettingløkke'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Superclamp'),
      200,
      scrollable: find.byType(Scrollable),
    );

    expect(find.text('Superclamp'), findsOneWidget);
    expect(find.text('6 profiler'), findsNWidgets(2));
  });
}
