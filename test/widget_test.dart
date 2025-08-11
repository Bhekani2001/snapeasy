import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snapeasy/main.dart';
import 'package:snapeasy/components/home_quick_actions.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Rewards and Buy show Coming Soon dialog', (WidgetTester tester) async {
    // Pump the widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HomeQuickActions(),
        ),
      ),
    );

    // Tap Rewards
    await tester.tap(find.text('Rewards'));
    await tester.pumpAndSettle(); // Wait for dialog to appear
    expect(find.text('Coming Soon!'), findsOneWidget);
    expect(find.textContaining('Stay tuned'), findsOneWidget);

    // Close dialog
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Tap Buy
    await tester.tap(find.text('Buy'));
    await tester.pumpAndSettle();
    expect(find.text('Coming Soon!'), findsOneWidget);
  });
}
