import 'package:snapeasy/models/notification_model.dart';
import 'notification_repository.dart';

class NotificationRepoImpl implements NotificationRepository {
  final List<NotificationModel> _notifications = [];

  @override
  Future<List<NotificationModel>> getNotifications() async {
    return _notifications;
  }

  @override
  Future<void> addNotification(NotificationModel notification) async {
    _notifications.add(notification);
  }

  @override
  Future<void> markAsRead(String id) async {
    final notif = _notifications.firstWhere((n) => n.id == id, orElse: () => NotificationModel(id: '', title: '', body: '', date: DateTime.now()));
    if (notif.id.isNotEmpty) {
      notif.read = true;
    }
  }

  @override
  Future<void> clearAll() async {
    _notifications.clear();
  }
}
