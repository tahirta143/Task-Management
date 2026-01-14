import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taskflow_app/splash_screens/on_boarding_screens.dart';


class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _opacity;
  late Animation<double> _scale;
  late Animation<double> _rotation;
  late Animation<Offset> _slide;

  late Animation<double> _textOpacity;
  late Animation<double> _textScale;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    // ✅ initialize controller FIRST
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    // -------- IMAGE ANIMATIONS --------
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.25, curve: Curves.easeIn),
      ),
    );

    _scale = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 0.55, curve: Curves.easeOutBack),
      ),
    );

    _rotation = Tween<double>(begin: 0, end: 0.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.55, 0.8, curve: Curves.easeInOut),
      ),
    );

    _slide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.8, 1.0, curve: Curves.easeOut),
      ),
    );

    // -------- TEXT ANIMATIONS --------
    _textOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    _textScale = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
      ),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    // Navigate after animation
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OnBoardingScreens(),
        ),
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
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _opacity.value,
                    child: Transform.scale(
                      scale: _scale.value,
                      child: Transform.rotate(
                        angle: _rotation.value,
                        child: SlideTransition(
                          position: _slide,
                          child: child,
                        ),
                      ),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 290,
                  height: 400,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // TEXT ANIMATION
            FadeTransition(
              opacity: _textOpacity,
              child: ScaleTransition(
                scale: _textScale,
                child: SlideTransition(
                  position: _textSlide,
                  child: const Text(
                    "Task",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF068BFF),
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}