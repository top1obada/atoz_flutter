import 'package:flutter/material.dart';

class FirstSplashScreen extends StatefulWidget {
  const FirstSplashScreen({super.key});

  @override
  State<FirstSplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<FirstSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controllerA;
  late AnimationController _controllerTO;
  late AnimationController _controllerZ;

  @override
  void initState() {
    super.initState();

    _controllerA = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _controllerTO = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _controllerZ = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // تسلسل تشغيل الأنيميشن
    _controllerA.forward().then((_) {
      _controllerTO.forward().then((_) {
        _controllerZ.forward().then((_) {
          // هون بتحط الحدث اللي بدك يشتغل بعد الأنيميشن
          // مثلا:
          // print("Splash انتهى ✅");
        });
      });
    });
  }

  @override
  void dispose() {
    _controllerA.dispose();
    _controllerTO.dispose();
    _controllerZ.dispose();
    super.dispose();
  }

  Widget _buildAnimatedText(String text, AnimationController controller) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.5,
        end: 1,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutBack)),
      child: FadeTransition(
        opacity: controller,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAnimatedText("A", _controllerA),
            const SizedBox(height: 10),
            _buildAnimatedText("TO", _controllerTO),
            const SizedBox(height: 10),
            _buildAnimatedText("Z", _controllerZ),
          ],
        ),
      ),
    );
  }
}
