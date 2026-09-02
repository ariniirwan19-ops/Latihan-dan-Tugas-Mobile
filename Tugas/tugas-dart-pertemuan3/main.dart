import 'exceptions.dart';
import 'produk.dart';
import 'keranjang.dart';
import 'toko_service.dart';

void main() async {
  print('=== SISTEM MANAJEMEN TOKO ONLINE ===\n');

  final toko = TokoService();

  toko.tambahProduk(
    ProdukDigital('D001', 'E-Book Flutter', 150000, 50, 25.5, 'PDF'),
  );
  toko.tambahProduk(
    ProdukDigital('D002', 'Video Course Dart', 300000, 30, 1024, 'MP4'),
  );
  toko.tambahProduk(
    ProdukFisik('F001', 'Buku Pemrograman', 120000, 20, 450, '20x15x3 cm'),
  );
  toko.tambahProduk(
    ProdukFisik('F002', 'Keyboard Mechanical', 750000, 5, 900, '45x15x5 cm'),
  );

  print('📦 Daftar Produk Tersedia:\n');

  // PERHATIAN: <Produk> di depan kurung siku sangat penting!
  for (var produk in <Produk>[
    ProdukDigital('D001', 'E-Book Flutter', 150000, 50, 25.5, 'PDF'),
    ProdukDigital('D002', 'Video Course Dart', 300000, 30, 1024, 'MP4'),
    ProdukFisik('F001', 'Buku Pemrograman', 120000, 20, 450, '20x15x3 cm'),
    ProdukFisik('F002', 'Keyboard Mechanical', 750000, 5, 900, '45x15x5 cm'),
  ]) {
    print('• ${produk.deskripsi()}');
    print(
      '  Harga: Rp ${produk.harga.toStringAsFixed(0)} | Stok: ${produk.stok}',
    );

    // PERBAIKAN MUTLAK: Casting eksplisit (produk as BisaDiskon)
    if (produk is BisaDiskon) {
      print(
        '  Harga diskon 10%: Rp ${(produk as BisaDiskon).hitungHargaDiskon(10).toStringAsFixed(0)}',
      );
    }
    print('');
  }

  print('\n🔍 TEST 1: Mencari Produk');
  try {
    final produk = await toko.cariProduk('Buku');
    print('✓ Ditemukan: ${produk.deskripsi()}');
  } catch (e) {
    print('✗ Error: $e');
  }

  print('\n🔍 TEST 2: Produk Tidak Ditemukan');
  try {
    await toko.cariProduk('Produk Tidak Ada');
  } catch (e) {
    print('✗ Error: $e');
  }

  print('\n🛒 TEST 3: Keranjang Belanja');
  final keranjang = Keranjang();

  try {
    final produk1 = await toko.cariProduk('E-Book');
    final produk2 = await toko.cariProduk('Keyboard');

    keranjang.tambah(produk1);
    keranjang.tambah(produk2);

    print('Total items: ${keranjang.jumlahItems}');
    print('Total harga: Rp ${keranjang.totalHarga().toStringAsFixed(0)}');
  } catch (e) {
    print('✗ Error: $e');
  }

  print('\n💳 TEST 4: Checkout Berhasil');
  try {
    final hasil = await toko.prosesCheckout(keranjang);
    print('✓ $hasil');
  } catch (e) {
    print('✗ Error: $e');
  }

  print('\n🚫 TEST 5: Checkout Stok Habis');
  final keranjang2 = Keranjang();

  try {
    final produk = await toko.cariProduk('Keyboard');
    for (int i = 0; i < 5; i++) {
      keranjang2.tambah(produk);
    }
    await toko.prosesCheckout(keranjang2);
  } catch (e) {
    print('✗ Error: $e');
  }

  print('\n=== PROGRAM SELESAI ===');
}
