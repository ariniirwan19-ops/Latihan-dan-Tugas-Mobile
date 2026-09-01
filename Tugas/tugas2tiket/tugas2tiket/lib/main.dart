import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:math';

// 1. Abstract class Tiket
abstract class Tiket {
  final String nama;
  final double harga;

  Tiket({required this.nama, required this.harga});

  String deskripsi();
}

// 2. Mixin BisaDiskon
mixin BisaDiskon {
  double hitungHargaDiskon(double persen, double harga) {
    return harga - (harga * persen / 100);
  }
}

// 3. Subclass TiketEkonomi
class TiketEkonomi extends Tiket with BisaDiskon {
  TiketEkonomi() : super(nama: 'Tiket Ekonomi', harga: 150000);

  @override
  String deskripsi() {
    return 'Tiket kelas ekonomi dengan fasilitas standar';
  }
}

// 4. Subclass TiketVIP
class TiketVIP extends Tiket with BisaDiskon {
  TiketVIP() : super(nama: 'Tiket VIP', harga: 350000);

  @override
  String deskripsi() {
    return 'Tiket kelas VIP dengan fasilitas premium dan lounge';
  }
}

// 5. Custom Exception
class TiketHabisException implements Exception {
  final String message;
  TiketHabisException(this.message);
}

// 6. Async function ambilDaftarTiket
Future<List<Tiket>> ambilDaftarTiket() async {
  await Future.delayed(Duration(seconds: 2));
  return [TiketEkonomi(), TiketVIP()];
}

// 7. Async function pesanTiket
Future<String> pesanTiket(Tiket tiket) async {
  await Future.delayed(Duration(seconds: 1));

  // Simulasi kegagalan acak
  if (Random().nextBool()) {
    throw TiketHabisException('Maaf, ${tiket.nama} sudah habis!');
  }

  return 'Berhasil memesan ${tiket.nama} seharga Rp${tiket.harga}';
}

// 8. Stream untuk countdown
Stream<int> countdownStream() async* {
  for (int i = 60; i >= 0; i--) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pemesanan Tiket',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HalamanDaftarTiket(),
    );
  }
}

// 9. Halaman utama dengan FutureBuilder
class HalamanDaftarTiket extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Tiket')),
      body: Column(
        children: [
          // Bonus: StreamBuilder countdown
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.orange[100],
            child: StreamBuilder<int>(
              stream: countdownStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    'Waktu tersisa untuk promo: ${snapshot.data} detik',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  );
                }
                return Text('Memuat waktu promo...');
              },
            ),
          ),
          // FutureBuilder untuk daftar tiket
          Expanded(
            child: FutureBuilder<List<Tiket>>(
              future: ambilDaftarTiket(),
              builder: (context, snapshot) {
                // Loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                // Error
                else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
                // Data
                else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final tiket = snapshot.data![index];
                      return Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(
                            tiket.nama,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tiket.deskripsi()),
                              Text(
                                'Rp${tiket.harga}',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          trailing: ElevatedButton(
                            child: Text('Pesan'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      HalamanPemesanan(tiket: tiket),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
                return Center(child: Text('Tidak ada data'));
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 10. Halaman pemesanan dengan try/catch/finally
class HalamanPemesanan extends StatefulWidget {
  final Tiket tiket;

  HalamanPemesanan({required this.tiket});

  @override
  _HalamanPemesananState createState() => _HalamanPemesananState();
}

class _HalamanPemesananState extends State<HalamanPemesanan> {
  String _pesan = '';
  bool _isLoading = false;

  Future<void> _prosesPemesanan() async {
    setState(() {
      _isLoading = true;
      _pesan = '';
    });

    try {
      final hasil = await pesanTiket(widget.tiket);
      setState(() {
        _pesan = '✓ $hasil';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_pesan), backgroundColor: Colors.green),
      );
    } on TiketHabisException catch (e) {
      setState(() {
        _pesan = '✗ ${e.message}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_pesan), backgroundColor: Colors.red),
      );
    } catch (e) {
      setState(() {
        _pesan = '✗ Terjadi kesalahan: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pemesanan ${widget.tiket.nama}')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Tiket:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Nama: ${widget.tiket.nama}'),
            Text('Harga: Rp${widget.tiket.harga}'),
            Text('Deskripsi: ${widget.tiket.deskripsi()}'),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    child: Text('Konfirmasi Pemesanan'),
                    onPressed: _prosesPemesanan,
                  ),
            if (_pesan.isNotEmpty) ...[
              SizedBox(height: 20),
              Text(
                _pesan,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
