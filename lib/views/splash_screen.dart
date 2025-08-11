import 'dart:async';
import 'package:flutter/material.dart';
import 'package:snapeasy/views/home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool _fadeIn = false;
  late AnimationController _bounceController;
  late AnimationController _rippleController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _bounceAnimation =
        CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut);

    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _rippleAnimation =
        Tween<double>(begin: 0.0, end: 15.0).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeInOut,
    ));

    Timer(const Duration(milliseconds: 800), () {
      setState(() => _fadeIn = true);
      _bounceController.forward();
    });

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 400;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6DD5FA),
              Color(0xFF2980B9),
              Color(0xFF56ab2f),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _rippleAnimation,
              builder: (context, child) {
                return Container(
                  padding: EdgeInsets.all((isWide ? 30 : 20) + _rippleAnimation.value),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.4),
                        blurRadius: 20 + _rippleAnimation.value,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Icon(
                    Icons.credit_card_rounded,
                    size: isWide ? 110 : 80,
                    color: Colors.white,
                    semanticLabel: 'App logo',
                  ),
                );
              },
            ),
            const SizedBox(height: 25),
            ScaleTransition(
              scale: _bounceAnimation,
              child: Text(
                "SnapEZ",
                style: TextStyle(
                  fontSize: isWide ? 44 : 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
                semanticsLabel: 'App name',
              ),
            ),
            const SizedBox(height: 10),
            AnimatedOpacity(
              opacity: _fadeIn ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 800),
              child: AnimatedSlide(
                offset: _fadeIn ? Offset(0, 0) : const Offset(0, 0.4),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOut,
                child: Text(
                  "Save • Pay • Secure",
                  style: TextStyle(
                    fontSize: isWide ? 22 : 18,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  semanticsLabel: 'App slogan',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
