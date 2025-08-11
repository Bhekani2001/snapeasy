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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 350,
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Notifications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
                if (state is NotificationLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is NotificationsLoaded) {
                  if (state.notifications.isEmpty) {
                    return Text('No notifications.');
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: state.notifications.length,
                    separatorBuilder: (_, __) => Divider(),
                    itemBuilder: (context, index) {
                      final notif = state.notifications[index];
                      return ListTile(
                        title: Text(notif.title),
                        subtitle: Text(notif.body),
                        trailing: notif.read ? null : Icon(Icons.circle, color: Colors.red, size: 12),
                        onTap: () {
                          BlocProvider.of<NotificationBloc>(context).add(MarkNotificationAsRead(notif.id));
                        },
                      );
                    },
                  );
                } else if (state is NotificationError) {
                  return Text('Error: ${state.message}');
                }
                return SizedBox.shrink();
              },
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text('Close', style: TextStyle(fontWeight: FontWeight.bold)),
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
