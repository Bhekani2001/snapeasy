import 'package:snapeasy/models/card_model.dart';


abstract class CardEvent {}

class InitializeCards extends CardEvent {}

class LoadCards extends CardEvent {}

class AddCard extends CardEvent {
  final CardModel card;
  AddCard(this.card);
}

class UpdateCard extends CardEvent {
  final CardModel card;
  UpdateCard(this.card);
}

class RemoveCard extends CardEvent {
  final String id;
  RemoveCard(this.id);
}

class ClearAllCards extends CardEvent {}

class FilterCardsByCountry extends CardEvent {
  final String country;
  FilterCardsByCountry(this.country);
}

class CardBanCheck extends CardEvent {
  final String cardType;
  final String country;
  CardBanCheck({required this.cardType, required this.country});
}