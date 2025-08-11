import 'package:snapeasy/models/notification_model.dart';

abstract class NotificationEvent {}

class LoadNotifications extends NotificationEvent {}
class AddNotification extends NotificationEvent {
  final NotificationModel notification;
  AddNotification(this.notification);
}
class MarkNotificationAsRead extends NotificationEvent {
  final String id;
  MarkNotificationAsRead(this.id);
}
class ClearNotifications extends NotificationEvent {}
