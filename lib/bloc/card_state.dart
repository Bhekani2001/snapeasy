import 'package:snapeasy/models/card_model.dart';

abstract class CardState {}

class CardInitial extends CardState {}

class CardLoading extends CardState {}

class CardsInitialized extends CardState {}

class CardAdded extends CardState {
  final CardModel card;
  CardAdded(this.card);
}

class CardUpdated extends CardState {
  final CardModel card;
  CardUpdated(this.card);
}

class CardRemoved extends CardState {
  final String id;
  CardRemoved(this.id);
}

class AllCardsCleared extends CardState {}

class CardsLoaded extends CardState {
  final List<CardModel> cards;
  CardsLoaded(this.cards);
}

class CardsFiltered extends CardState {
  final List<CardModel> cards;
  final String country;
  CardsFiltered(this.cards, this.country);
}

class CardError extends CardState {
  final String message;
  CardError(this.message);
}

class CardBanChecked extends CardState {
  final bool isBanned;
  final String? bannedMessage;
  CardBanChecked({required this.isBanned, this.bannedMessage});
}

class CardBanned extends CardState {
  final String bannedMessage;
  CardBanned(this.bannedMessage);
}