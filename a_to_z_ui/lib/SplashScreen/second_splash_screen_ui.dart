import 'package:a_to_z_providers/BasesProviders/base_current_login_info_provider.dart';
import 'package:a_to_z_providers/LoginProviders/customer_login_by_username_provider.dart';
import 'package:a_to_z_ui/CustomerLoginUI/customer_login_ui.dart';
import 'package:a_to_z_ui/CustomerMainMenuUI/customer_main_menu_ui.dart';
import 'package:a_to_z_ui/MusicUI/music_ui.dart';
import 'package:flutter/material.dart';
import 'package:a_to_z_providers/RefreshTokenProviders/refresh_token_provider.dart';
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
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _slideAnimation;
  bool _hasNavigated = false;

  final List<String> _letters = ['A', 'TO', 'Z'];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.8, curve: Curves.easeInOutCubic),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
      ),
    );

    _rotationAnimation = Tween<double>(begin: 2 * pi, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 2.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.9, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed && !_hasNavigated) {
        _hasNavigated = true;
        await _executeAfterAnimation();
      }
    });
  }

  Future<void> _executeAfterAnimation() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      PVRefreshToken refreshToken = PVRefreshToken();

      var result = await refreshToken.login();

      if (result) {
        PVBaseCurrentLoginInfo currentLoginInfo = refreshToken;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (con) {
              return MultiProvider(
                providers: [
                  ChangeNotifierProvider(create: (_) => PVRotations()),
                  ChangeNotifierProvider.value(value: currentLoginInfo),
                  ChangeNotifierProvider(
                    create: (_) {
                      var pv = PVSong();
                      pv.start();
                      return pv;
                    },
                  ),
                  ChangeNotifierProvider(
                    create: (_) => PVMainMenuUiPagesProvider(),
                  ),
                ],
                child: const CustomerMainMenuUi(),
              );
            },
          ),
        );
        return;
      }

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
                child: const CustomerLoginScreenUI(),
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

  Widget _buildLetter(String letter, int index) {
    double delay = index * 0.2;
    double letterProgress = max(0.0, (_controller.value - delay) / 0.6);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double wave = sin(letterProgress * pi * 4 + index) * 0.1;
        double scale = 0.8 + letterProgress * 0.4;
        double rotation = sin(letterProgress * pi * 2) * 0.1;

        return Transform(
          transform:
              Matrix4.identity()
                ..scale(scale + wave)
                ..rotateZ(rotation),
          alignment: Alignment.center,
          child: Opacity(
            opacity: letterProgress.clamp(0.0, 1.0),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.amber.shade300,
                    Colors.orange.shade400,
                    Colors.deepOrange.shade400,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
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
              child: Text(
                letter,
                style: TextStyle(
                  fontSize: letter == 'TO' ? 28 : 42,
                  fontWeight: FontWeight.bold,
                  foreground:
                      Paint()
                        ..shader = LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.amber.shade100,
                            Colors.white,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.7),
                      blurRadius: 12,
                      offset: const Offset(3, 3),
                    ),
                    Shadow(
                      color: Colors.orange.withValues(alpha: 0.4),
                      blurRadius: 10,
                      offset: const Offset(-2, -2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
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
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Enhanced icon with golden border effect
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: RotationTransition(
                        turns: _rotationAnimation,
                        child: Container(
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
                      ),
                    ),
                    const SizedBox(height: 40),

                    // A TO Z letters with beautiful animations
                    SlideTransition(
                      position: _slideAnimation,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_letters.length, (index) {
                          return _buildLetter(_letters[index], index);
                        }),
                      ),
                    ),

                    // Beautiful Arabic tagline with enhanced styling
                    const SizedBox(height: 50),
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
                                  stops: const [0.0, 0.4, 0.8, 1.0],
                                ).createShader(bounds),
                            child: Text(
                              "كل ما تحتاجه العائلة",
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
