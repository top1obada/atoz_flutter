import 'package:flutter/material.dart';
import 'package:my_widgets/SearchWidgets/words_line.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: TextSelectorLine(
          wordItems: [
            WordItem('الكل', Colors.grey),
            WordItem('بقالة', Colors.blue),
            WordItem('صيدلية', Colors.purple),
          ],
          onWordSelected: (c) {},
        ),
      ),
    );
  }
}
