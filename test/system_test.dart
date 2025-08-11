import 'package:flutter_test/flutter_test.dart';
import 'package:snapeasy/bloc/card_event.dart';
import 'package:snapeasy/bloc/card_state.dart';
import 'package:snapeasy/bloc/notification_event.dart';
import 'package:snapeasy/bloc/notification_state.dart';
import 'package:snapeasy/bloc/notification_event.dart'; 
import 'package:snapeasy/main.dart';
import 'package:snapeasy/views/home_screen.dart';
import 'package:snapeasy/views/add_card_manual.dart';
import 'package:snapeasy/repositories/card_repository.dart';
import 'package:snapeasy/repositories/notification_repository.dart';
import 'package:snapeasy/view_models/card_viewmodel.dart';
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
      await tester.pumpWidget(MaterialApp(home: AddCardManualScreen(
        key: Key('manualForm'),
      )));
      // Simulate user input for card fields
  await tester.enterText(find.byKey(Key('cardNumberField')), '4000001234567890');
  await tester.enterText(find.byKey(Key('firstNameField')), 'John');
  await tester.enterText(find.byKey(Key('lastNameField')), 'Doe');
  await tester.enterText(find.byKey(Key('cvvField')), '123');
  await tester.enterText(find.byKey(Key('expiryField')), '12/28');
  await tester.enterText(find.byKey(Key('cityField')), 'New York');
  await tester.enterText(find.byKey(Key('pinField')), '1234');
  // Select country from dropdown
  await tester.tap(find.byKey(Key('countryDropdown')));
  await tester.pumpAndSettle();
  await tester.tap(find.text('USA').last);
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(Key('saveButton')));
  await tester.pumpAndSettle();
  expect(find.textContaining('success'), findsOneWidget);
    });


    testWidgets('Scan Card screen loads and has expected widgets', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: AddCardScanScreen()));
      expect(find.byType(AddCardScanScreen), findsOneWidget);
      expect(find.byType(TextField), findsWidgets);
    });


    testWidgets('My Cards screen displays saved cards', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: MyCardsScreen()));
      expect(find.byType(MyCardsScreen), findsOneWidget);
      expect(find.textContaining('Card'), findsWidgets);
    });


    test('CardBloc loads cards and handles events', () async {
      final repo = _MockCardRepository();
      final viewModel = CardViewModel(repo);
      final bloc = CardBloc(viewModel);
      bloc.add(LoadCards());
      await expectLater(
        bloc.stream,
        emits(isA<CardsLoaded>()),
      );
    });


  });
}

class _MockCardRepository extends CardRepository {
  final List<CardModel> _cards = [
    CardModel(cardNumber: '4000001234567890', firstName: 'John', lastName: 'Doe', cvv: '123', expiry: '12/28', country: 'USA', city: 'New York', pin: '1234', cardType: 'Visa', bankName: 'Bank of America')
  ];

  @override
  Future<List<CardModel>> getCards() async => _cards;

  @override
  Future<CardModel?> getCardById(String id) async {
    try {
      return _cards.firstWhere((c) => c.cardNumber == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addCard(CardModel card) async => _cards.add(card);

  @override
  Future<void> updateCard(CardModel card) async {
    final idx = _cards.indexWhere((c) => c.cardNumber == card.cardNumber);
    if (idx != -1) _cards[idx] = card;
  }

  @override
  Future<void> removeCard(String id) async => _cards.removeWhere((c) => c.cardNumber == id);

  @override
  Future<bool> isCardExists(String cardNumber) async => _cards.any((c) => c.cardNumber == cardNumber);

  @override
  Future<void> clearAllCards() async => _cards.clear();

  @override
  Future<int> getCardCount() async => _cards.length;

  @override
  Future<void> migrateOldCardsIfNeeded() async {}
}

class _MockNotificationRepository extends NotificationRepository {
  final List<NotificationModel> _notifications = [
    NotificationModel(id: '1', title: 'Expiry Alert', body: 'Card expiring soon', read: false, date: DateTime.now())
  ];

  @override
  Future<List<NotificationModel>> getNotifications() async => _notifications;

  @override
  Future<void> addNotification(NotificationModel notification) async {
    _notifications.add(notification);
  }

  @override
  Future<void> clearAll() async {
    _notifications.clear();
  }

  @override
  Future<void> markAsRead(String id) async {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1) _notifications[idx] = NotificationModel(
      id: _notifications[idx].id,
      title: _notifications[idx].title,
      body: _notifications[idx].body,
      read: true,
      date: _notifications[idx].date,
    );
  }
}
