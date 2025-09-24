import 'package:flutter/material.dart';
import 'tip_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestroe Tip Calculator - MVP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes:{
        '/': (contect) => const TipCalculatorPage(title: 'Firebase Tip Calculator'),
      }
    );
  }
}
