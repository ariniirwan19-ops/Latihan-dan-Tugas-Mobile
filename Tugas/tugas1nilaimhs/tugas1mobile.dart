void main() {

  final Map<String, Map<String, dynamic>> mahasiswa = {
    'M001': {
      'nama': 'Budi Santoso',
      'nilai': [85, 90, 78, 92, 88],
      'absensi': 2,
    },
    'M002': {
      'nama': 'Siti Rahayu',
      'nilai': [55, 60, 58, 52, 45],
      'absensi': 2,
    },
    'M003': {
      'nama': 'Andi Pratama',
      'nilai': [75, 80, 78, 82, 76],
      'absensi': 1,
    },
    'M004': {
      'nama': 'Dina Lestari',
      'nilai': [65, 70, 68, 72, 60],
      'absensi': 4,
    },
    'M005': {
      'nama': 'Rizky Maulana',
      'nilai': [90, 85, 95, 88, 92],
      'absensi': 1,
    },
  };

  print('=== LAPORAN NILAI MAHASISWA ===');

  List<int> semuaNilai = [];

  mahasiswa.forEach((id, data) {
    final String nama = data['nama'];
    final List<int> nilai = data['nilai'];
    final int absensi = data['absensi'];

    final double rataRata = hitungRataRata(nilai);
    final String grade = tentukanGrade(rataRata);
    final bool lulus = cekKelulusan(
      rataRata: rataRata,
      absensi: absensi,
    );

    semuaNilai.addAll(nilai);

    print('\nNama      : $nama');
    print('Nilai     : $nilai');
    print('Absensi   : $absensi');
    print('Rata-rata : ${rataRata.toStringAsFixed(1)}');
    print('Grade     : $grade');
    print('Status    : ${lulus ? 'LULUS' : 'TIDAK LULUS'}');
  });


  final int nilaiTertinggi = semuaNilai.reduce(
    (a, b) => a > b ? a : b,
  );

  final int nilaiTerendah = semuaNilai.reduce(
    (a, b) => a < b ? a : b,
  );

  final double rataRataKelas = hitungRataRata(semuaNilai);

  print('\n=== STATISTIK KELAS ===');
  print('Nilai Tertinggi : $nilaiTertinggi');
  print('Nilai Terendah  : $nilaiTerendah');
  print('Rata-rata Kelas : ${rataRataKelas.toStringAsFixed(1)}');
}


// FUNGSI MENGHITUNG RATA-RATA
double hitungRataRata(List<int> nilai) {
  int total = nilai.reduce((a, b) => a + b);
  return total / nilai.length;
}


// FUNGSI MENENTUKAN GRADE
String tentukanGrade(double rataRata) {
  if (rataRata >= 90) {
    return 'A';
  } else if (rataRata >= 80) {
    return 'B';
  } else if (rataRata >= 70) {
    return 'C';
  } else if (rataRata >= 60) {
    return 'D';
  } else {
    return 'E';
  }
}


// FUNGSI CEK KELULUSAN
bool cekKelulusan({
  required double rataRata,
  required int absensi,
}) {
  return rataRata >= 60 && absensi <= 3;
}