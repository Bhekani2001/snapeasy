import 'package:flutter_test/flutter_test.dart';
import 'package:snapeasy/bloc/card_bloc.dart';
import 'package:snapeasy/bloc/card_event.dart';
import 'package:snapeasy/bloc/card_state.dart';
import 'package:snapeasy/view_models/card_viewmodel.dart';
import 'package:snapeasy/models/card_model.dart';
import 'package:snapeasy/repositories/card_repository.dart';

class MockCardRepository extends CardRepository {
  final List<CardModel> _cards = [];

  @override
  Future<List<CardModel>> getCards() async => _cards;
  @override
  Future<CardModel?> getCardById(String id) async => _cards.firstWhere((c) => c.cardNumber == id, orElse: () => CardModel(cardNumber: '', firstName: '', lastName: '', cvv: '', expiry: '', country: '', city: '', pin: '', cardType: '', bankName: ''));
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

void main() {
  group('CardBloc Logic Tests', () {
    late CardBloc bloc;
    late MockCardRepository repo;
    late CardViewModel viewModel;

    setUp(() {
      repo = MockCardRepository();
      viewModel = CardViewModel(repo);
      bloc = CardBloc(viewModel);
    });

    test('Initial state is CardInitial', () {
      expect(bloc.state, isA<CardInitial>());
    });

    test('LoadCards emits CardLoading then CardsLoaded', () async {
      bloc.add(LoadCards());
      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<CardLoading>(),
          isA<CardsLoaded>(),
        ]),
      );
    });

    test('AddCard emits CardLoading, CardAdded, then CardsLoaded', () async {
      final card = CardModel(cardNumber: '4000001234567890', firstName: 'John', lastName: 'Doe', cvv: '123', expiry: '12/28', country: 'USA', city: 'NY', pin: '1234', cardType: 'Visa', bankName: 'Bank of America');
      bloc.add(AddCard(card));
      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<CardLoading>(),
          isA<CardAdded>(),
          isA<CardsLoaded>(),
        ]),
      );
    });

    test('RemoveCard emits CardLoading, CardRemoved, then CardsLoaded', () async {
      final card = CardModel(cardNumber: '4000001234567890', firstName: 'John', lastName: 'Doe', cvv: '123', expiry: '12/28', country: 'USA', city: 'NY', pin: '1234', cardType: 'Visa', bankName: 'Bank of America');
      repo._cards.add(card);
      bloc.add(RemoveCard(card.cardNumber));
      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<CardLoading>(),
          isA<CardRemoved>(),
          isA<CardsLoaded>(),
        ]),
      );
    });

    test('ClearAllCards emits CardLoading, AllCardsCleared, then CardsLoaded', () async {
      repo._cards.add(CardModel(cardNumber: '4000001234567890', firstName: 'John', lastName: 'Doe', cvv: '123', expiry: '12/28', country: 'USA', city: 'NY', pin: '1234', cardType: 'Visa', bankName: 'Bank of America'));
      bloc.add(ClearAllCards());
      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<CardLoading>(),
          isA<AllCardsCleared>(),
          isA<CardsLoaded>(),
        ]),
      );
    });
  });
}
