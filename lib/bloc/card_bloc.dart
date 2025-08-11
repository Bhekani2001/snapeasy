import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapeasy/bloc/card_event.dart';
import 'package:snapeasy/bloc/card_state.dart';
import 'package:snapeasy/models/card_model.dart';
import 'package:snapeasy/view_models/card_viewmodel.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  final CardViewModel viewModel;

  CardBloc(this.viewModel) : super(CardInitial()) {
    on<InitializeCards>(_onInitialize);
    on<LoadCards>(_onLoadCards);
    on<AddCard>(_onAddCard);
    on<UpdateCard>(_onUpdateCard);
    on<RemoveCard>(_onRemoveCard);
    on<ClearAllCards>(_onClearAllCards);
    on<FilterCardsByCountry>(_onFilterCardsByCountry);
  }

  Future<void> _onInitialize(InitializeCards event, Emitter<CardState> emit) async {
    emit(CardLoading());
    try {
      await viewModel.initialize();
      emit(CardsInitialized());
      add(LoadCards());
    } catch (e, st) {
      emit(CardError('Initialization failed: $e'));
    }
  }

  Future<void> _onLoadCards(LoadCards event, Emitter<CardState> emit) async {
    emit(CardLoading());
    try {
      final cards = await viewModel.getCards();
      emit(CardsLoaded(cards));
    } catch (e, st) {
      emit(CardError('Failed to load cards: $e'));
    }
  }

  Future<void> _onAddCard(AddCard event, Emitter<CardState> emit) async {
    emit(CardLoading());
    try {
      final validation = await viewModel.validateCard(event.card);
      if (!validation.isValid) {
        emit(CardError(validation.error ?? 'Validation failed'));
        return;
      }
      final result = await viewModel.addCard(event.card);
      if (result.success) {
        emit(CardAdded(event.card));
        add(LoadCards());
      } else {
        emit(CardError(result.error ?? 'Failed to add card'));
      }
    } catch (e, st) {
      emit(CardError('Failed to add card: $e'));
    }
  }

  Future<void> _onUpdateCard(UpdateCard event, Emitter<CardState> emit) async {
    emit(CardLoading());
    try {
      final validation = await viewModel.validateCard(event.card);
      if (!validation.isValid) {
        emit(CardError(validation.error ?? 'Validation failed'));
        return;
      }
      final result = await viewModel.updateCard(event.card);
      if (result.success) {
        final cards = await viewModel.getCards();
        final updatedCard = cards.firstWhere(
          (c) => c.id == event.card.id,
          orElse: () => event.card,
        );
        emit(CardUpdated(updatedCard));
        add(LoadCards());
      } else {
        emit(CardError(result.error ?? 'Failed to update card'));
      }
    } catch (e, st) {
      emit(CardError('Failed to update card: $e'));
    }
  }

  Future<void> _onRemoveCard(RemoveCard event, Emitter<CardState> emit) async {
    emit(CardLoading());
    try {
      await viewModel.removeCard(event.id);
      emit(CardRemoved(event.id));
      add(LoadCards());
    } catch (e, st) {
      emit(CardError('Failed to remove card: $e'));
    }
  }

  Future<void> _onClearAllCards(ClearAllCards event, Emitter<CardState> emit) async {
    emit(CardLoading());
    try {
      await viewModel.clearAllCards();
      emit(AllCardsCleared());
      add(LoadCards());
    } catch (e, st) {
      emit(CardError('Failed to clear cards: $e'));
    }
  }

  Future<void> _onFilterCardsByCountry(FilterCardsByCountry event, Emitter<CardState> emit) async {
    emit(CardLoading());
    try {
      final cards = await viewModel.getCardsByCountry(event.country);
      emit(CardsFiltered(cards, event.country));
    } catch (e, st) {
      emit(CardError('Failed to filter cards: $e'));
    }
  }
}