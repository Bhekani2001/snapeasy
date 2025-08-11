import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapeasy/bloc/notification_event.dart';
import 'package:snapeasy/bloc/notification_state.dart';
import 'package:snapeasy/models/notification_model.dart';
import 'package:snapeasy/repositories/notification_repository.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;

  NotificationBloc(this.repository) : super(NotificationInitial()) {
    on<LoadNotifications>(_onLoad);
    on<AddNotification>(_onAdd);
    on<MarkNotificationAsRead>(_onMarkRead);
    on<ClearNotifications>(_onClear);
  }

  Future<void> _onLoad(LoadNotifications event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    try {
      final notifs = await repository.getNotifications();
      emit(NotificationsLoaded(notifs));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onAdd(AddNotification event, Emitter<NotificationState> emit) async {
    await repository.addNotification(event.notification);
    add(LoadNotifications());
  }

  Future<void> _onMarkRead(MarkNotificationAsRead event, Emitter<NotificationState> emit) async {
    await repository.markAsRead(event.id);
    add(LoadNotifications());
  }

  Future<void> _onClear(ClearNotifications event, Emitter<NotificationState> emit) async {
    await repository.clearAll();
    add(LoadNotifications());
  }
}
