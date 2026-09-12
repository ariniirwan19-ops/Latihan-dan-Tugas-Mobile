import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('BREAKING NEWS',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 155, 11, 1) 
          ),),
          
        ),
        
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(height: 10.0, thickness: 1.0),
            SizedBox(height: 10,),
            Text("PEMBUNUHAN BERENCANA DI TERNATE, MALUKU UTARA",
            style: TextStyle(
              fontSize: 15,
            ),),
            SizedBox(height: 10,),
            Row(children: [
              Icon(Icons.person, color: const Color.fromARGB(255, 255, 135, 175), size: 20,),
              Text("Penulis: Arini"),
              SizedBox(width: 10,),
              Icon(Icons.calendar_month, color: const Color.fromARGB(255, 209, 66, 56), size: 20,),
              Text("02-11-2030")
            ],),
            SizedBox(height: 10,),
            Divider(height: 5.0, thickness: 1.0,),
            SizedBox(height: 10,),
            Text("Pembunuhan berencana dilakukan di Ternate, Maluku Utara. Polisi telah menangkap tersangka dan sedang melakukan penyelidikan lebih lanjut. Korban ditemukan di rumahnya dengan luka tusukan. Masyarakat diminta untuk tetap tenang dan mempercayakan proses hukum kepada pihak berwenang.",)
            ]
        ),
      ),
    );
  }
}