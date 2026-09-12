import 'package:flutter/material.dart';

String kategoriRating(double r) => r >= 4.5 ? 'Sangat Baik' : r >= 3.5 ? 'Baik' : 'Cukup';

final List<Map<String, dynamic>> daftarBuku = [
  {'judul': 'Laskar Pelangi', 'pengarang': 'Andrea Hirata', 'tahunTerbit': 2005, 'rating': 4.8, 'tersedia': true, 'genre': 'Novel'},
  {'judul': 'Bumi Manusia', 'pengarang': 'Pramoedya Ananta Toer', 'tahunTerbit': 1980, 'rating': 4.7, 'tersedia': false, 'genre': 'Sejarah'},
  {'judul': 'Negeri 5 Menara', 'pengarang': 'Ahmad Fuadi', 'tahunTerbit': 2009, 'rating': 4.4, 'tersedia': true, 'genre': 'Novel'},
  {'judul': 'Filosofi Teras', 'pengarang': 'Henry Manampiring', 'tahunTerbit': 2018, 'rating': 4.6, 'tersedia': true, 'genre': 'Pengembangan Diri'},
  {'judul': 'Atomic Habits', 'pengarang': 'James Clear', 'tahunTerbit': 2018, 'rating': 4.9, 'tersedia': false, 'genre': 'Pengembangan Diri'},
  {'judul': 'Bicara Itu Ada Seninya', 'pengarang': 'Oh Su Hyang', 'tahunTerbit': 2018, 'rating': 3.8, 'tersedia': true, 'genre': 'Komunikasi'},
];

void main() => runApp(const PerpustakaanApp());

class PerpustakaanApp extends StatelessWidget {
  const PerpustakaanApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner: false, title: 'Perpustakaan Mini', home: const HalamanKatalog());
}

class HalamanKatalog extends StatefulWidget {
  const HalamanKatalog({super.key});
  @override
  State<HalamanKatalog> createState() => _HalamanKatalogState();
}

class _HalamanKatalogState extends State<HalamanKatalog> {
  final searchCtrl = TextEditingController();
  String kataPencarian = '', genreTerpilih = '';
  Set<String> get genreUnik => daftarBuku.map((b) => b['genre'] as String).toSet();  
  @override
  void dispose() { searchCtrl.dispose(); super.dispose(); }
  
  @override
  Widget build(BuildContext context) {
    final hasil = daftarBuku.where((b) => 
      (kataPencarian.isEmpty || b['judul'].toString().toLowerCase().contains(kataPencarian.toLowerCase())) &&
      (genreTerpilih.isEmpty || b['genre'] == genreTerpilih)
    ).toList();
    
    return Scaffold(
      appBar: AppBar(title: const Text('Katalog Buku Perpustakaan Mini')),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(12),
          child: TextField(controller: searchCtrl, onChanged: (v) => setState(() => kataPencarian = v),
            decoration: InputDecoration(labelText: 'Cari buku berdasarkan judul', hintText: 'Masukkan judul buku...', 
              prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
        ),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Align(alignment: Alignment.centerLeft,
            child: Wrap(spacing: 8, runSpacing: 4, children: [
              FilterChip(label: const Text('Semua'), selected: genreTerpilih.isEmpty, onSelected: (_) => setState(() => genreTerpilih = '')),
              ...genreUnik.map((g) => FilterChip(label: Text(g), selected: genreTerpilih == g, onSelected: (_) => setState(() => genreTerpilih = g))),
            ])),
        ),
        Expanded(child: ListView.builder(itemCount: hasil.length,
          itemBuilder: (context, i) {
            final b = hasil[i];
            return Card(margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Padding(padding: const EdgeInsets.all(12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(b['judul'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text('Pengarang: ${b['pengarang']}'),
                  Text('Tahun Terbit: ${b['tahunTerbit']}'),
                  Text('Rating: ${b['rating']} (${kategoriRating(b['rating'])})'),
                  Text('Genre: ${b['genre']}'),
                  const SizedBox(height: 8),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: b['tersedia'] ? Colors.green : Colors.red, borderRadius: BorderRadius.circular(20)),
                    child: Text(b['tersedia'] ? 'Tersedia' : 'Dipinjam', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  const SizedBox(height: 8),
                  Align(alignment: Alignment.centerRight,
                    child: ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HalamanDetailBuku(buku: b))),
                      child: const Text('Lihat Detail'))),
                ])),
            );
          })),
      ]),
    );
  }
}

class HalamanDetailBuku extends StatefulWidget {
  final Map<String, dynamic> buku;
  const HalamanDetailBuku({super.key, required this.buku});
  @override
  State<HalamanDetailBuku> createState() => _HalamanDetailBukuState();
}

class _HalamanDetailBukuState extends State<HalamanDetailBuku> {
  String? catatanPeminjam;
  final catatanCtrl = TextEditingController();
  @override
  void dispose() { catatanCtrl.dispose(); super.dispose(); }
  
  @override
  Widget build(BuildContext context) {
    final b = widget.buku;
    return Scaffold(appBar: AppBar(title: const Text('Detail Buku')),
      body: Padding(padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(b['judul'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text('Pengarang: ${b['pengarang']}'),
          Text('Tahun Terbit: ${b['tahunTerbit']}'),
          Text('Rating: ${b['rating']}'),
          Text('Kategori: ${kategoriRating(b['rating'])}'),
          Text('Genre: ${b['genre']}'),
          const SizedBox(height: 20),
          TextField(controller: catatanCtrl, decoration: const InputDecoration(labelText: 'Catatan Peminjam', hintText: 'Masukkan catatan...', border: OutlineInputBorder())),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: () => setState(() => catatanPeminjam = catatanCtrl.text), child: const Text('Simpan Catatan')),
          const SizedBox(height: 15),
          Text('Catatan: ${catatanPeminjam ?? 'Tidak ada catatan'}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ])),
    );
  }
}