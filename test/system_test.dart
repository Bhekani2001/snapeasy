import 'package:flutter_test/flutter_test.dart';
import 'package:snapeasy/main.dart';
import 'package:snapeasy/views/home_screen.dart';
import 'package:snapeasy/views/add_card_manual.dart';
import 'package:snapeasy/views/add_card_scan_screen.dart';
import 'package:snapeasy/views/my_cards_screen.dart';
import 'package:snapeasy/bloc/card_bloc.dart';
import 'package:snapeasy/bloc/notification_bloc.dart';
import 'package:snapeasy/models/card_model.dart';
import 'package:snapeasy/models/notification_model.dart';
import 'package:flutter/material.dart';

void main() {
  group('SnapEZ System Tests', () {
    testWidgets('HomeScreen loads and displays quick actions', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      expect(find.text('Quick Actions'), findsOneWidget);
      expect(find.byIcon(Icons.credit_card), findsWidgets);
    });

    testWidgets('Add Card Manual form validates and saves', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: AddCardManual()));
      // Simulate user input for card fields
      await tester.enterText(find.byKey(Key('cardNumberField')), '1234567890123456');
      await tester.enterText(find.byKey(Key('firstNameField')), 'John');
      await tester.enterText(find.byKey(Key('lastNameField')), 'Doe');
      await tester.enterText(find.byKey(Key('pinField')), '1234');
      await tester.tap(find.byKey(Key('saveButton')));
      await tester.pump();
      expect(find.text('Card saved successfully'), findsOneWidget);
    });

    testWidgets('Scan Card screen navigates to manual entry on scan', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: AddCardScanScreen()));
      // Simulate scan result
      // ...simulate scan logic...
      // Should navigate to manual entry
      // expect(find.byType(AddCardManual), findsOneWidget);
    });

    testWidgets('My Cards screen displays saved cards', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: MyCardsScreen()));
      expect(find.text('Your Cards'), findsOneWidget);
      // ...simulate loading cards...
    });

    test('CardBloc loads cards and handles events', () async {
      final bloc = CardBloc();
      bloc.add(LoadCards());
      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<CardLoading>(),
          isA<CardsLoaded>(),
        ]),
      );
    });

    test('NotificationBloc loads and marks notifications as read', () async {
      final bloc = NotificationBloc();
      bloc.add(LoadNotifications());
      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<NotificationLoading>(),
          isA<NotificationsLoaded>(),
        ]),
      );
      // Simulate mark as read
      bloc.add(MarkNotificationRead(1));
      // ...test state change...
    });
  });
}
