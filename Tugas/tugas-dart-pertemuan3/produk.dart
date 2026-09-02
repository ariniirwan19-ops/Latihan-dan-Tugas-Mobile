mixin BisaDiskon {
  double get harga;

  double hitungHargaDiskon(double persen) {
    if (!validasiDiskon(persen)) {
      throw ArgumentError('Persentase diskon harus antara 0 - 100');
    }
    return harga - (harga * persen / 100);
  }

  bool validasiDiskon(double persen) {
    return persen >= 0 && persen <= 100;
  }
}

abstract class Produk {
  final String id;
  final String nama;
  final double harga;
  int stok;

  Produk(this.id, this.nama, this.harga, this.stok);

  String deskripsi();
}

class ProdukDigital extends Produk with BisaDiskon {
  final double ukuranMB;
  final String formatFile;

  ProdukDigital(String id, String nama, double harga, int stok, this.ukuranMB, this.formatFile)
      : super(id, nama, harga, stok);

  @override
  String deskripsi() {
    return 'Produk Digital: $nama ($formatFile.toUpperCase()}, {$ukuranMB}MB)';
  }
}

class ProdukFisik extends Produk with BisaDiskon {
  final double beratKg;
  final String dimensi;

  ProdukFisik(String id, String nama, double harga, int stok, this.beratKg, this.dimensi)
      : super(id, nama, harga, stok);

  @override
  String deskripsi() {
    return 'Produk Fisik: $nama (Berat: ${beratKg}kg, Dimensi: $dimensi)';
  }
}
