import 'dart:async';
import 'package:flutter/material.dart';
import '../auth/login_page.dart';  // ✅ Relative import

class Flashscreen extends StatefulWidget {
  const Flashscreen({super.key});  // ✅ Constructor = nama class

  @override
  State<Flashscreen> createState() => _FlashscreenState();
}

class _FlashscreenState extends State<Flashscreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {  // ✅ Tambah const
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),  // ✅ Tambah const
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(  // ✅ Tambah const
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6366F1), Color(0xFF4F46E5), Color(0xFF4338CA)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: const Icon(Icons.check, color: Colors.indigo),  // ✅ Tambah const & color
            ),
            const SizedBox(height: 16),
            const Text(
              "Task Flow",
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              "Organize Your Task \nAchieve Your Goals",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 60),
            const CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}