class StokHabisException implements Exception {
  final String namaProduk;

  StokHabisException(this.namaProduk);

  @override
  String toString() => 'StokHabisException: Stok untuk produk "$namaProduk" habis.';

}

class ProdukTidakAda implements Exception {
  final String namaProduk;

  ProdukTidakAda(this.namaProduk);

  @override
  String toString() => 'ProdukTidakAda: Produk "$namaProduk" tidak ditemukan.';
}