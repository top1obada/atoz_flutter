import 'package:a_to_z_providers/LoginProviders/customer_login_by_username_provider.dart';
import 'package:a_to_z_ui/CustomerLoginUI/customer_login_ui.dart';
import 'package:a_to_z_ui/MusicUI/music_ui.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _hasNavigated = false; // Prevent multiple navigations

  String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    _controller.forward();

    // === ADD THIS LISTENER FOR THE EVENT AFTER ANIMATION COMPLETES ===
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_hasNavigated) {
        _hasNavigated = true;
        _executeAfterAnimation();
      }
    });
  }

  // === ADD THIS METHOD FOR YOUR EVENT ===
  void _executeAfterAnimation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) => MultiProvider(
                providers: [
                  ChangeNotifierProvider.value(
                    value: PVCustomerLoginByUsername(),
                  ),
                ],
                child: MaterialApp(home: const CustomerLoginScreenUI()),
              ),
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
        width: double.infinity,
        height: double.infinity,
        child: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            int lettersToShow =
                (alphabet.length * _fadeAnimation.value).floor();

            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.lerp(
                      Colors.indigo.shade900,
                      Colors.purple.shade800,
                      _fadeAnimation.value,
                    )!,
                    Color.lerp(
                      Colors.blue.shade800,
                      Colors.deepPurple.shade700,
                      _fadeAnimation.value,
                    )!,
                    Color.lerp(
                      Colors.purple.shade600,
                      Colors.blue.shade900,
                      _fadeAnimation.value,
                    )!,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Enhanced icon with golden border effect
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.amber.shade300,
                            Colors.orange.shade400,
                            Colors.deepOrange.shade400,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withValues(alpha: 0.6),
                            blurRadius: 20,
                            spreadRadius: 3,
                            offset: const Offset(0, 5),
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 15,
                            spreadRadius: 2,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.asset(
                            'assets/app_icon2.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Animated letters container with enhanced styling
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate(lettersToShow, (index) {
                          double wave = sin(
                            _fadeAnimation.value * pi * 2 + index / 2,
                          );
                          return Transform.translate(
                            offset: Offset(0, wave * 8),
                            child: Transform.scale(
                              scale: 0.8 + (_fadeAnimation.value * 0.5),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.amber.withValues(
                                        alpha: 0.4,
                                      ),
                                      blurRadius: 15,
                                      offset: const Offset(0, 0),
                                    ),
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.4,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  alphabet[index],
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                    foreground:
                                        Paint()
                                          ..shader = LinearGradient(
                                            colors: [
                                              Colors.amber.shade200,
                                              Colors.orange.shade400,
                                              Colors.deepOrange.shade400,
                                            ],
                                            stops: [0.0, 0.5, 1.0],
                                          ).createShader(
                                            const Rect.fromLTWH(0, 0, 200, 70),
                                          ),
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.7,
                                        ),
                                        blurRadius: 12,
                                        offset: const Offset(3, 3),
                                      ),
                                      Shadow(
                                        color: Colors.amber.withValues(
                                          alpha: 0.4,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(-2, -2),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    // Beautiful Arabic tagline with enhanced styling
                    const SizedBox(height: 45),
                    AnimatedOpacity(
                      opacity: _fadeAnimation.value > 0.5 ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 800),
                      child: Transform.scale(
                        scale: 1.0 + (_fadeAnimation.value * 0.1),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.amber.withValues(alpha: 0.3),
                                Colors.orange.withValues(alpha: 0.2),
                                Colors.deepOrange.withValues(alpha: 0.3),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Colors.amber.withValues(alpha: 0.5),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.6),
                                blurRadius: 25,
                                spreadRadius: 3,
                                offset: const Offset(0, 8),
                              ),
                              BoxShadow(
                                color: Colors.amber.withValues(alpha: 0.3),
                                blurRadius: 20,
                                spreadRadius: 2,
                                offset: const Offset(0, -5),
                              ),
                            ],
                          ),
                          child: ShaderMask(
                            shaderCallback:
                                (bounds) => RadialGradient(
                                  center: Alignment.center,
                                  radius: 2.0,
                                  colors: [
                                    Colors.amber.shade200,
                                    Colors.orange.shade400,
                                    Colors.deepOrange.shade400,
                                    Colors.amber.shade100,
                                  ],
                                  stops: [0.0, 0.4, 0.8, 1.0],
                                ).createShader(bounds),
                            child: Text(
                              "كل ما تحتاجه من الألف إلى الياء",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 1.8,
                                height: 1.5,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.9),
                                    blurRadius: 15,
                                    offset: const Offset(3, 3),
                                  ),
                                  Shadow(
                                    color: Colors.orange.withValues(alpha: 0.6),
                                    blurRadius: 20,
                                    offset: const Offset(-3, -3),
                                  ),
                                  Shadow(
                                    color: Colors.amber.withValues(alpha: 0.4),
                                    blurRadius: 25,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
