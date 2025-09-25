import 'dart:async';
import 'package:flutter/material.dart';

class AlphabetLoader extends StatefulWidget {
  const AlphabetLoader({Key? key}) : super(key: key);

  @override
  State<AlphabetLoader> createState() => _AlphabetLoaderState();
}

class _AlphabetLoaderState extends State<AlphabetLoader>
    with SingleTickerProviderStateMixin {
  final letters = List.generate(26, (i) => String.fromCharCode(65 + i));
  int index = 0;
  late Timer timer;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      lowerBound: 0.8,
      upperBound: 1.2,
    )..repeat(reverse: true);

    timer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      setState(() => index = (index + 1) % letters.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: controller,
      child: Text(
        letters[index],
        style: const TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    timer.cancel();
    super.dispose();
  }
}
