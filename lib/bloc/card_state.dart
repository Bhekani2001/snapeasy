import 'package:snapeasy/models/card_model.dart';

abstract class CardState {
  const CardState();
}

class CardInitial extends CardState {
  const CardInitial();
}

class CardLoading extends CardState {
  const CardLoading();
}

class CardsInitialized extends CardState {
  const CardsInitialized();
}

class CardAdded extends CardState {
  final CardModel card;
  const CardAdded(this.card);
}

class CardUpdated extends CardState {
  final CardModel card;
  const CardUpdated(this.card);
}

class CardRemoved extends CardState {
  final String id;
  const CardRemoved(this.id);
}

class AllCardsCleared extends CardState {
  const AllCardsCleared();
}

class CardsLoaded extends CardState {
  final List<CardModel> cards;
  const CardsLoaded(this.cards);
}

class CardsFiltered extends CardState {
  final List<CardModel> cards;
  final String country;
  const CardsFiltered(this.cards, this.country);
}

class CardError extends CardState {
  final String message;
  const CardError(this.message);
}

class CardBanChecked extends CardState {
  final bool isBanned;
  final String? bannedMessage;
  const CardBanChecked({required this.isBanned, this.bannedMessage});
}

class CardBanned extends CardState {
  final String bannedMessage;
  const CardBanned(this.bannedMessage);
}