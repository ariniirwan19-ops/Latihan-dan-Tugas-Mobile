import 'package:flutter/material.dart';

class FlashScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<FlashScreen> createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: AlignmentGeometry.bottomRight,
            colors: [Color(0xFF6366F1), Color(0xFF4F46E5), Color(0xFF4338CA)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, //posisi kotak ke tengah
          children: [
            Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.check),
            ),

            SizedBox(height: 15), // ini untuk jarak antara kotak ke text

            Text(
              "Task Flow",
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),

            SizedBox(height: 15), // ini untuk jarak antara text ke text

            Text(
              "Organize Your Task \n Achieve Your Goals",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),

            SizedBox(height: 60), // ini untuk jarak antara kotak ke text

            CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          ],
        ),
      ),
    );
  }
}