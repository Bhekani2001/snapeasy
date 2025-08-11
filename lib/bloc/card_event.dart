import 'package:snapeasy/models/card_model.dart';

abstract class CardEvent {
  const CardEvent();
}

class InitializeCards extends CardEvent {
  const InitializeCards();
}

class LoadCards extends CardEvent {
  const LoadCards();
}

class AddCard extends CardEvent {
  final CardModel card;
  const AddCard(this.card);
}

class UpdateCard extends CardEvent {
  final CardModel card;
  const UpdateCard(this.card);
}

class RemoveCard extends CardEvent {
  final String id;
  const RemoveCard(this.id);
}

class ClearAllCards extends CardEvent {
  const ClearAllCards();
}

class FilterCardsByCountry extends CardEvent {
  final String country;
  const FilterCardsByCountry(this.country);
}

class CardBanCheck extends CardEvent {
  final String cardType;
  final String country;
  const CardBanCheck({required this.cardType, required this.country});
}