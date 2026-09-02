import 'produk.dart';

class Keranjang {
  final List<Produk> _items = [];

  void tambah(Produk produk) {
    _items.add(produk);
    print('Produk "${produk.nama}" berhasil ditambahkan ke keranjang.');
  }

  void hapus(String idProduk) {
    _items.removeWhere((item) => item.id == idProduk);
    print('Produk dengan ID "$idProduk" berhasil dihapus dari keranjang.');
  }

  double totalHarga() {
    return _items.fold(0, (total, item) => total + item.harga);
  }

  List<Produk> get items => _items;
  int get jumlahItems => _items.length;
}
