import 'package:snapeasy/models/notification_model.dart';
import 'notification_repository.dart';

class NotificationRepoImpl implements NotificationRepository {
  final List<NotificationModel> _notifications = [];

  @override
  Future<List<NotificationModel>> getNotifications() async {
    return List.unmodifiable(_notifications);
  }

  @override
  Future<void> addNotification(NotificationModel notification) async {
    _notifications.add(notification);
  }

  @override
  Future<void> markAsRead(String id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final notif = _notifications[index];
      _notifications[index] = notif.copyWith(read: true);
    }
  }

  @override
  Future<void> clearAll() async {
    _notifications.clear();
  }
}
