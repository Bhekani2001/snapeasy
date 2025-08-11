import 'package:snapeasy/models/notification_model.dart';
import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object?> get props => [];
}

class LoadNotifications extends NotificationEvent {
  const LoadNotifications();
}

class AddNotification extends NotificationEvent {
  final NotificationModel notification;
  const AddNotification(this.notification);
  @override
  List<Object?> get props => [notification];
}

class MarkNotificationAsRead extends NotificationEvent {
  final String id;
  const MarkNotificationAsRead(this.id);
  @override
  List<Object?> get props => [id];
}

class ClearNotifications extends NotificationEvent {
  const ClearNotifications();
}
