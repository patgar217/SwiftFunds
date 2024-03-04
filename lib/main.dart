import 'package:flutter/material.dart';
import 'package:swiftfunds/Views/auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SwiftFunds',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xA6DE9A)),
        useMaterial3: true,
      ),
      home: const AuthScreen()
    );
  }
}
