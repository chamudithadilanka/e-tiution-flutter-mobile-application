import 'package:flutter/material.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _moveAnimation; // Floating effect

  @override
  void initState() {
    super.initState();

    // Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true); // Repeat for floating effect

    // Fade-in animation
    _opacityAnimation = Tween<double>(
      begin: 0.3, // Start fully transparent
      end: 1.0, // Fully visible
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // Scale animation (Pop-in effect)
    _scaleAnimation = Tween<double>(
      begin: 0.5, // Start smaller
      end: 1.0, // Normal size
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    // Floating animation (Moves image up and down)
    _moveAnimation = Tween<Offset>(
      begin: Offset(0, 0.00), // Start at normal position
      end: Offset(0, -0.03), // Move slightly up
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Navigate to login page after 3 seconds
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [kMainColor, kMainDarkBlue],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Floating Image
            SlideTransition(
              position: _moveAnimation,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _opacityAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Image.asset(
                  "assets/images/413144-PDTI0Y-350.png",
                  width: 280,
                  height: 280,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Animated Text
            FadeTransition(
              opacity: _opacityAnimation,
              child: const Text(
                "E TUITION",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
