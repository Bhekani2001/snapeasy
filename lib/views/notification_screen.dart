import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapeasy/bloc/notification_bloc.dart';
import 'package:snapeasy/bloc/notification_state.dart';
import 'package:snapeasy/bloc/notification_event.dart';
import 'package:snapeasy/models/notification_model.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Container(
        width: 370,
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.notifications_active, color: Color(0xFF2980B9), size: 28),
                const SizedBox(width: 10),
                Text('Notifications', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 18),
            BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
                if (state is NotificationLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is NotificationsLoaded) {
                  if (state.notifications.isEmpty) {
                    return const Text('No notifications.', style: TextStyle(color: Colors.black54));
                  }
                  return SizedBox(
                    height: 260,
                    child: ListView.separated(
                      itemCount: state.notifications.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final notif = state.notifications[index];
                        return ListTile(
                          title: Text(notif.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(notif.body, style: const TextStyle(color: Colors.black87)),
                          trailing: notif.read ? null : const Icon(Icons.circle, color: Colors.red, size: 12),
                          onTap: () {
                            BlocProvider.of<NotificationBloc>(context).add(MarkNotificationAsRead(notif.id));
                          },
                          tileColor: notif.read ? Colors.grey[100] : Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        );
                      },
                    ),
                  );
                } else if (state is NotificationError) {
                  return Text('Error: ${state.message}', style: const TextStyle(color: Colors.redAccent));
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: const Text('Close', style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
