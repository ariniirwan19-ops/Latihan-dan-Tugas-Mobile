import 'exceptions.dart';
import 'produk.dart';
import 'keranjang.dart';

class TokoService {
  final List<Produk> _database = [];

  void tambahProduk(Produk produk) {
    _database.add(produk);
  }

  Future<Produk> cariProduk(String nama) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final produk = _database.firstWhere(
        (p) => p.nama.toLowerCase().contains(nama.toLowerCase()),
      );
      return produk;
    } catch (e) {
      throw ProdukTidakAda(nama);
    }
  }

  Future<String> prosesCheckout(Keranjang keranjang) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    try {
      // Hitung total permintaan per produk
      Map<String, int> jumlahDiminta = {};
      for (var p in keranjang.items) {
        jumlahDiminta[p.id] = (jumlahDiminta[p.id] ?? 0) + 1;
      }

      // Cek stok berdasarkan total permintaan
      for (var entry in jumlahDiminta.entries) {
        var produk = keranjang.items.firstWhere((p) => p.id == entry.key);
        if (produk.stok < entry.value) {
          throw StokHabisException(
            '${produk.nama} (Diminta: ${entry.value}, Tersedia: ${produk.stok})',
          );
        }
      }

      // Kurangi stok jika validasi lolos
      for (var entry in jumlahDiminta.entries) {
        var produk = keranjang.items.firstWhere((p) => p.id == entry.key);
        produk.stok -= entry.value;
      }

      final total = keranjang.totalHarga();
      return 'Checkout berhasil! Total: Rp ${total.toStringAsFixed(0)}';
    } catch (e) {
      rethrow;
    }
  }
}
