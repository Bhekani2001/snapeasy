import 'package:snapeasy/models/notification_model.dart';

abstract class NotificationRepository {
  Future<List<NotificationModel>> getNotifications();
  Future<void> addNotification(NotificationModel notification);
  Future<void> markAsRead(String id);
  Future<void> clearAll();
}
