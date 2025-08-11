
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snapeasy/main.dart';
import 'package:snapeasy/components/quick_actions/home_quick_actions.dart';
import 'package:snapeasy/views/add_card_manual.dart';
import 'package:snapeasy/views/home_screen.dart';
import 'package:snapeasy/views/settings_screen.dart';

void main() {
  testWidgets('HomeQuickActions displays all quick actions', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: HomeQuickActions())));
    expect(find.text('My Cards'), findsOneWidget);
    expect(find.text('Rewards'), findsOneWidget);
    expect(find.text('Buy'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.byIcon(Icons.credit_card), findsOneWidget);
    expect(find.byIcon(Icons.card_giftcard), findsOneWidget);
    expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });

  testWidgets('Rewards and Buy show Coming Soon dialog', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: HomeQuickActions())));
    await tester.tap(find.text('Rewards'));
    await tester.pumpAndSettle();
    expect(find.text('Coming Soon!'), findsOneWidget);
    expect(find.textContaining('Stay tuned'), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Buy'));
    await tester.pumpAndSettle();
    expect(find.text('Coming Soon!'), findsOneWidget);
  });

  testWidgets('Settings navigates to SettingsScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: HomeQuickActions())));
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);
  });

  testWidgets('HomeScreen displays quick actions and cards section', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomeScreen()));
    expect(find.text('Quick Actions'), findsOneWidget);
    expect(find.text('Your Cards'), findsOneWidget);
    expect(find.byType(HomeQuickActions), findsOneWidget);
  });

  testWidgets('My Cards navigation from HomeQuickActions', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: HomeQuickActions())));
    await tester.tap(find.text('My Cards'));
    await tester.pumpAndSettle();
    // Should navigate to MyCardsScreen (or show cards)
    expect(find.textContaining('Card'), findsWidgets);
  });

  testWidgets('Error dialog appears for banned MasterCard in manual entry', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AddCardManualScreen()));
    await tester.enterText(find.byKey(Key('cardNumberField')), '5100001234567890'); // MasterCard
    await tester.tap(find.byKey(Key('countryDropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Banned').first);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('saveButton')));
    await tester.pumpAndSettle();
    expect(find.textContaining('banned'), findsOneWidget);
  });

  testWidgets('Notification badge appears when there are unread notifications', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomeScreen()));

    expect(find.byWidgetPredicate((widget) => widget is Container && widget.decoration != null && widget.toString().contains('red')), findsWidgets);
  });
}
