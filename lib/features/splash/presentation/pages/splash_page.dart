import 'package:flutter/material.dart';
import 'package:flight_hours_app/core/services/session_service.dart';

/// Animated splash screen displayed after the native splash.
///
/// Shows the Flight Hours logo with a scale + fade-in animation,
/// followed by the app name, then navigates to the appropriate
/// screen based on whether the user has an active session.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    // — Logo animation: fade-in + scale (0→1s) —
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _logoFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeIn));

    // — Text animation: fade-in + slide up (delayed 400ms after logo starts) —
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _textFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    // Start animation sequence
    _startAnimations();
  }

  Future<void> _startAnimations() async {
    // Small delay so native splash can fade out smoothly
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    // Start logo animation
    _logoController.forward();

    // After logo is halfway, start text
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    _textController.forward();

    // Wait for everything to complete, then navigate
    await Future.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    final isLoggedIn = SessionService().isLoggedIn;

    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(isLoggedIn ? '/home' : '/', (route) => false);
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // — Animated Logo —
            AnimatedBuilder(
              animation: _logoController,
              builder: (context, child) {
                return Opacity(
                  opacity: _logoFade.value,
                  child: Transform.scale(scale: _logoScale.value, child: child),
                );
              },
              child: Image.asset(
                'assets/images/flight_hours_logo.png',
                width: 200,
                height: 200,
              ),
            ),

            const SizedBox(height: 32),

            // — Animated Text —
            SlideTransition(
              position: _textSlide,
              child: FadeTransition(
                opacity: _textFade,
                child: const Text(
                  'FlightHours',
                  style: TextStyle(
                    color: Color(0xFFE5A33A), // Gold accent matching logo
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
