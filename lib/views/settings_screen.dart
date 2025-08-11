import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  final settings = const [
    {'title': 'Card Settings', 'icon': Icons.credit_card},
    {'title': 'Transaction Settings', 'icon': Icons.receipt_long},
    {'title': 'Notifications', 'icon': Icons.notifications},
    {'title': 'Security', 'icon': Icons.lock},
    {'title': 'About', 'icon': Icons.info},
  ];

  Widget _glassContainer({required Widget child, double borderRadius = 20}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.2,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildTopCard(BuildContext context) {
    return BounceInDown(
      duration: const Duration(milliseconds: 800),
      child: _glassContainer(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 36, color: Color(0xFF2980B9)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  "Welcome back,\nHere's your settings hub!",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile(BuildContext context, Map<String, dynamic> item, int index) {
    return FadeInUp(
      duration: Duration(milliseconds: 400 + (index * 100)),
      child: _glassContainer(
        borderRadius: 14,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {},
          splashColor: Colors.white.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(item['icon'] as IconData, color: Colors.white, size: 26),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item['title'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.white70),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Settings',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: settings.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildTopCard(context);
            }
            return _buildSettingTile(context, settings[index - 1], index - 1);
          },
        ),
      ),
    );
  }
}
