import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const TiketApp());
}

abstract class Tiket {
  final String nama;
  final double harga;

  Tiket(this.nama, this.harga);

  String deskripsi();
}

mixin BisaDiskon on Tiket {
  double hitungHargaDiskon(double persen) {
    return harga - (harga * persen / 100);
  }
}

class TiketEkonomi extends Tiket {
  TiketEkonomi(String nama, double harga) : super(nama, harga);

  @override
  String deskripsi() =>
      'Tiket Ekonomi dengan fasilitas standar. Cocok untuk perjalanan hemat.';
}

class TiketVIP extends Tiket with BisaDiskon {
  TiketVIP(String nama, double harga) : super(nama, harga);

  @override
  String deskripsi() =>
      'Tiket VIP dengan fasilitas eksklusif: kursi premium, lounge, dan prioritas boarding.';
}

class TiketHabisException implements Exception {
  final String message;
  TiketHabisException(this.message);

  @override
  String toString() => message;
}

Future<List<Tiket>> ambilDaftarTiket() async {
  await Future.delayed(const Duration(seconds: 2));

  final gagal = Random().nextInt(100) < 15;
  if (gagal) {
    throw Exception(
      'Gagal memuat daftar tiket. Periksa koneksi internet Anda.',
    );
  }

  return [
    TiketEkonomi('Konser Musik Indie', 150000),
    TiketVIP('Konser Musik Indie', 500000),
    TiketEkonomi('Nonton Bioskop Reguler', 50000),
    TiketVIP('Nonton Bioskop Premiere', 200000),
    TiketEkonomi('Kereta Eksekutif Jakarta-Bandung', 120000),
    TiketVIP('Kereta Eksekutif Jakarta-Bandung (Suite)', 450000),
  ];
}

Future<String> pesanTiket(Tiket tiket) async {
  await Future.delayed(const Duration(seconds: 2));

  final habis = Random().nextBool();
  if (habis) {
    throw TiketHabisException(
      'Maaf, tiket "${tiket.nama}" baru saja habis terjual. Silakan coba tiket lain.',
    );
  }

  return 'Tiket "${tiket.nama}" berhasil dipesan! Terima kasih telah memesan.';
}

class TiketApp extends StatelessWidget {
  const TiketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simulasi Pemesanan Tiket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF3949AB),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
      ),
      home: const DaftarTiketPage(),
    );
  }
}

class DaftarTiketPage extends StatefulWidget {
  const DaftarTiketPage({super.key});

  @override
  State<DaftarTiketPage> createState() => _DaftarTiketPageState();
}

class _DaftarTiketPageState extends State<DaftarTiketPage> {
  late Future<List<Tiket>> _futureTiket;

  @override
  void initState() {
    super.initState();
    _futureTiket = ambilDaftarTiket();
  }

  void _muatUlang() {
    setState(() {
      _futureTiket = ambilDaftarTiket();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulasi Pemesanan Tiket'),
        actions: [
          IconButton(
            onPressed: _muatUlang,
            icon: const Icon(Icons.refresh),
            tooltip: 'Muat ulang',
          ),
        ],
      ),
      body: Column(
        children: [
          const _CountdownPromoBanner(),

          Expanded(
            child: FutureBuilder<List<Tiket>>(
              future: _futureTiket,
              builder: (context, snapshot) {
                // Kondisi 1: LOADING
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Memuat daftar tiket...'),
                      ],
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.redAccent,
                            size: 48,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${snapshot.error}'.replaceFirst('Exception: ', ''),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _muatUlang,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final daftarTiket = snapshot.data ?? [];
                if (daftarTiket.isEmpty) {
                  return const Center(child: Text('Tidak ada tiket tersedia.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: daftarTiket.length,
                  itemBuilder: (context, index) {
                    final tiket = daftarTiket[index];
                    return _KartuTiket(tiket: tiket);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _KartuTiket extends StatelessWidget {
  final Tiket tiket;
  const _KartuTiket({required this.tiket});

  @override
  Widget build(BuildContext context) {
    final bool vip = tiket is TiketVIP;
    final formatRupiah =
        'Rp${tiket.harga.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PemesananPage(tiket: tiket)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: vip
                    ? Colors.amber.shade600
                    : Colors.blueGrey.shade300,
                child: Icon(
                  vip ? Icons.workspace_premium : Icons.confirmation_number,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tiket.nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tiket.deskripsi(),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formatRupiah,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3949AB),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class PemesananPage extends StatefulWidget {
  final Tiket tiket;
  const PemesananPage({super.key, required this.tiket});

  @override
  State<PemesananPage> createState() => _PemesananPageState();
}

class _PemesananPageState extends State<PemesananPage> {
  bool _sedangMemproses = false;
  String? _pesanSukses;
  String? _pesanGagal;

  Future<void> _prosesPesanTiket() async {
    setState(() {
      _sedangMemproses = true;
      _pesanSukses = null;
      _pesanGagal = null;
    });

    try {
      final hasil = await pesanTiket(widget.tiket);
      setState(() => _pesanSukses = hasil);
    } on TiketHabisException catch (e) {
      // Menangani kegagalan spesifik: tiket habis
      setState(() => _pesanGagal = e.toString());
    } catch (e) {
      // Menangani error tak terduga lainnya
      setState(() => _pesanGagal = 'Terjadi kesalahan: $e');
    } finally {
      // Selalu dijalankan, baik sukses maupun gagal
      setState(() => _sedangMemproses = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tiket = widget.tiket;
    final vip = tiket is TiketVIP;

    return Scaffold(
      appBar: AppBar(title: const Text('Pemesanan Tiket')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          vip
                              ? Icons.workspace_premium
                              : Icons.confirmation_number,
                          color: vip ? Colors.amber.shade700 : Colors.blueGrey,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            tiket.nama,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(tiket.deskripsi()),
                    const SizedBox(height: 12),
                    Text('Harga normal: Rp${tiket.harga.toStringAsFixed(0)}'),

                    // Jika TiketVIP (punya mixin BisaDiskon), tampilkan harga promo.
                    if (tiket is BisaDiskon)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Harga promo (diskon 10%): '
                          'Rp${(tiket as BisaDiskon).hitungHargaDiskon(10).toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Tombol pesan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _sedangMemproses ? null : _prosesPesanTiket,
                icon: _sedangMemproses
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.shopping_cart_checkout),
                label: Text(_sedangMemproses ? 'Memproses...' : 'Pesan Tiket'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Hasil: sukses
            if (_pesanSukses != null)
              _HasilBanner(
                pesan: _pesanSukses!,
                warna: Colors.green,
                ikon: Icons.check_circle,
              ),

            // Hasil: gagal
            if (_pesanGagal != null)
              _HasilBanner(
                pesan: _pesanGagal!,
                warna: Colors.redAccent,
                ikon: Icons.cancel,
              ),
          ],
        ),
      ),
    );
  }
}

class _HasilBanner extends StatelessWidget {
  final String pesan;
  final Color warna;
  final IconData ikon;

  const _HasilBanner({
    required this.pesan,
    required this.warna,
    required this.ikon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: warna.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: warna.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Icon(ikon, color: warna),
          const SizedBox(width: 10),
          Expanded(
            child: Text(pesan, style: TextStyle(color: warna.withOpacity(0.9))),
          ),
        ],
      ),
    );
  }
}

class _CountdownPromoBanner extends StatefulWidget {
  const _CountdownPromoBanner();

  @override
  State<_CountdownPromoBanner> createState() => _CountdownPromoBannerState();
}

class _CountdownPromoBannerState extends State<_CountdownPromoBanner> {
  static const _totalDetik = 5 * 60; // 5 menit
  late final Stream<int> _countdownStream;

  @override
  void initState() {
    super.initState();
    _countdownStream = Stream.periodic(
      const Duration(seconds: 1),
      (tick) => _totalDetik - tick - 1,
    ).take(_totalDetik + 1);
  }

  String _formatWaktu(int detik) {
    final d = detik.clamp(0, _totalDetik);
    final menit = (d ~/ 60).toString().padLeft(2, '0');
    final sisaDetik = (d % 60).toString().padLeft(2, '0');
    return '$menit:$sisaDetik';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _countdownStream,
      initialData: _totalDetik,
      builder: (context, snapshot) {
        final sisa = snapshot.data ?? 0;
        final habis = sisa <= 0;

        return Container(
          width: double.infinity,
          color: habis ? Colors.grey.shade400 : const Color(0xFF3949AB),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Row(
            children: [
              const Icon(Icons.timer, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  habis
                      ? 'Waktu promo telah berakhir'
                      : 'Waktu tersisa untuk memesan tiket promo: ${_formatWaktu(sisa)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

