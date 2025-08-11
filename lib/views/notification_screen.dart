import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapeasy/bloc/notification_bloc.dart';
import 'package:snapeasy/bloc/notification_state.dart';
import 'package:snapeasy/bloc/notification_event.dart';
import 'package:snapeasy/models/notification_model.dart';
import 'package:snapeasy/views/home_screen.dart';
import 'package:snapeasy/views/card_notifications_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  Widget _glassContainer({
    required Widget child,
    double borderRadius = 20,
    Color? borderColor,
    Color? gradientStart,
    Color? gradientEnd,
    Color? shadowColor,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                (gradientStart ?? Colors.white.withOpacity(0.15)),
                (gradientEnd ?? Colors.white.withOpacity(0.06)),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: (borderColor ?? Colors.white.withOpacity(0.18)),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: (shadowColor ?? Colors.black.withOpacity(0.07)),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color gradientStart,
    required Color gradientEnd,
    Widget? content,
  }) {
    return _glassContainer(
      gradientStart: gradientStart.withOpacity(0.3),
      gradientEnd: gradientEnd.withOpacity(0.1),
      borderColor: gradientStart.withOpacity(0.4),
      shadowColor: gradientStart.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 32),
                const SizedBox(width: 14),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: iconColor,
                  ),
                ),
              ],
            ),
            if (content != null) ...[
              const SizedBox(height: 16),
              content,
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state is NotificationLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is NotificationsLoaded) {
          if (state.notifications.isEmpty) {
            return const Text('No notifications yet.',
                style: TextStyle(color: Colors.black54));
          }
          return Column(
            children: List.generate(state.notifications.length, (index) {
              final notif = state.notifications[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _glassContainer(
                  borderRadius: 14,
                  gradientStart: Colors.grey.shade200.withOpacity(0.3),
                  gradientEnd: Colors.grey.shade100.withOpacity(0.1),
                  borderColor: Colors.grey.shade300.withOpacity(0.5),
                  shadowColor: Colors.black.withOpacity(0.05),
                  child: ListTile(
                    title: Text(
                      notif.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(notif.body,
                        style: const TextStyle(color: Colors.black87)),
                    trailing: notif.read
                        ? null
                        : const Icon(Icons.circle,
                            color: Colors.red, size: 12),
                    onTap: () {
                      BlocProvider.of<NotificationBloc>(context)
                          .add(MarkNotificationAsRead(notif.id));
                    },
                    tileColor:
                        notif.read ? Colors.grey[100] : Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              );
            }),
          );
        } else if (state is NotificationError) {
          return Text('Error loading notifications: ${state.message}',
              style: const TextStyle(color: Colors.red));
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF0E9DC), Color(0xFFE1DCCB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Notifications',
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            tooltip: 'Back to Home',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen()),
              );
            },
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 500;
            final horizontalPadding =
                isWide ? constraints.maxWidth * 0.2 : 16.0;

            return ListView(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: 16),
              physics: const BouncingScrollPhysics(),
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CardNotificationsScreen()),
                    );
                  },
                    child: _buildSectionCard(
                      title: 'Card Notifications',
                      icon: Icons.credit_card,
                      iconColor: Colors.deepOrange.shade700,
                      gradientStart: Colors.deepOrange.shade200,
                      gradientEnd: Colors.deepOrange.shade50,
                    ),
                ),
                const SizedBox(height: 20),
                _buildSectionCard(
                  title: 'Messaging Notifications',
                  icon: Icons.message,
                  iconColor: Colors.indigo.shade700,
                  gradientStart: Colors.indigo.shade200,
                  gradientEnd: Colors.indigo.shade50,
                ),
                const SizedBox(height: 20),
                _buildSectionCard(
                  title: 'Transactions Notifications',
                  icon: Icons.receipt_long,
                  iconColor: Colors.teal.shade700,
                  gradientStart: Colors.teal.shade200,
                  gradientEnd: Colors.teal.shade50,
                ),
                const SizedBox(height: 20),
                _buildSectionCard(
                  title: 'All Notifications',
                  icon: Icons.notifications_active,
                  iconColor: Colors.deepPurple.shade700,
                  gradientStart: Colors.deepPurple.shade200,
                  gradientEnd: Colors.deepPurple.shade50,
                  content: _buildNotificationList(context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
