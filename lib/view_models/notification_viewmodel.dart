import 'package:snapeasy/models/notification_model.dart';
import 'package:snapeasy/repositories/notification_repository.dart';

class NotificationViewModel {
  final NotificationRepository repository;
  NotificationViewModel(this.repository);

  Future<List<NotificationModel>> getNotifications() async {
    return await repository.getNotifications();
  }

  Future<void> addNotification(NotificationModel notification) async {
    await repository.addNotification(notification);
  }

  Future<void> markAsRead(String id) async {
    await repository.markAsRead(id);
  }

  Future<void> clearAll() async {
    await repository.clearAll();
  }
}
