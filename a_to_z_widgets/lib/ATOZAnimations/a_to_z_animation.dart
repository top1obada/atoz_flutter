import 'package:flutter/material.dart';

class AtoZLoader extends StatefulWidget {
  const AtoZLoader({Key? key}) : super(key: key);

  @override
  State<AtoZLoader> createState() => _AtoZLoaderState();
}

class _AtoZLoaderState extends State<AtoZLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: controller,
      child: ShaderMask(
        shaderCallback:
            (bounds) => LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent],
            ).createShader(bounds),
        child: const Text(
          'A TO Z',
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: Colors.white, // لازم يكون أبيض ليستقبل التدرج
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
