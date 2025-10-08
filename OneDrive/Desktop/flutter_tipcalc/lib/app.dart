import 'package:flutter/material.dart';
import 'auth_gate.dart';
import 'tip_view.dart';
import 'home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.clientId});

  final String clientId;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Tip Calculator - MVP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: AuthGate(clientId: clientId),
      routes: {
        '/calculator': (context) =>
            const TipCalculatorPage(title: 'Firebase Tip Calculator'),
        '/history': (context) =>
            const HistoryPage(title: 'Tip History'),
      },
    );
  }
}
