import 'package:flutter/material.dart';
import 'widgets/flash_screen.dart';  // ✅ "widgets" (jamak)
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) =>
      const MaterialApp(
        debugShowCheckedModeBanner: false, 
        home: Scaffold(body: Flashscreen(),)
  );
}