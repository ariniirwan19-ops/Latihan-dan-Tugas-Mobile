import 'package:flutter/material.dart';
import 'package:widget/widgets/flash_screen.dart'; // Pastikan nama package sesuai pubspec.yaml

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FlashScreen(),
    );
  }
}