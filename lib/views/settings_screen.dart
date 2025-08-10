import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  final settings = [
    {'title': 'Card Settings', 'icon': Icons.credit_card, 'onTap': () {}},
    {'title': 'Transaction Settings', 'icon': Icons.receipt_long, 'onTap': () {}},
    {'title': 'Notifications', 'icon': Icons.notifications, 'onTap': () {}},
    {'title': 'Security', 'icon': Icons.lock, 'onTap': () {}},
    {'title': 'About', 'icon': Icons.info, 'onTap': () {}},
  ];

  // Top card anims
  late final AnimationController _cardController;
  late final Animation<Offset> _cardSlide;
  late final Animation<double> _cardScale;

  // List anims
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _fadeAnimations;
  late final List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();

    // Top card animation controller + animations
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _cardSlide = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOutBack,
    ));

    _cardScale = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.elasticOut),
    );

    // Generate controllers for each list item
    _controllers = List.generate(settings.length, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );
    });

    // Create fade & slide animations for each controller
    _fadeAnimations = _controllers
        .map((controller) => CurvedAnimation(parent: controller, curve: Curves.easeOut))
        .toList();

    _slideAnimations = _controllers
        .map((controller) => Tween<Offset>(
              begin: const Offset(0, 0.2),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: controller, curve: Curves.elasticOut)),
        )
        .toList();

    // Start animations (card first, then staggered list)
    _playAnimations();
  }

  Future<void> _playAnimations() async {
    _cardController.forward();
    // Wait a little so top card appears first
    await Future.delayed(const Duration(milliseconds: 360));

    for (var i = 0; i < _controllers.length; i++) {
      // small delay between items
      await Future.delayed(const Duration(milliseconds: 110));
      _controllers[i].forward();
    }
  }

  @override
  void dispose() {
    _cardController.dispose();
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Widget _buildTopCard() {
    return ScaleTransition(
      scale: _cardScale,
      child: SlideTransition(
        position: _cardSlide,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: const Color(0xFF2980B9),
          elevation: 6,
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile(Map<String, dynamic> item, int index) {
    return SlideTransition(
      position: _slideAnimations[index],
      child: FadeTransition(
        opacity: _fadeAnimations[index],
        child: InkWell(
          onTap: item['onTap'] as VoidCallback,
          splashColor: Colors.blue.withOpacity(0.08),
          highlightColor: Colors.blue.withOpacity(0.04),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(item['icon'] as IconData, color: const Color(0xFF2980B9)),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item['title'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF2980B9),
        elevation: 0,
      ),
      body: ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: settings.length + 1,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildTopCard(),
            );
          }
          return _buildSettingTile(settings[index - 1], index - 1);
        },
      ),
    );
  }
}
