import 'package:snapeasy/models/notification_model.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}
class NotificationLoading extends NotificationState {}
class NotificationsLoaded extends NotificationState {
  final List<NotificationModel> notifications;
  NotificationsLoaded(this.notifications);
}
class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}
