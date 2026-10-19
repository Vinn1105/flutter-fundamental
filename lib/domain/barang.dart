/// Model representasi data Item / Barang untuk aplikasi belanja.
/// Mendukung atribut: id, nama, harga, foto, stok, dan rating sesuai spesifikasi tugas.
class Barang {
  final int id;
  final String nama;
  final int harga;
  final String foto;
  final int stok;
  final double rating;

  const Barang({
    required this.id,
    required this.nama,
    required this.harga,
    required this.foto,
    required this.stok,
    required this.rating,
  });

  /// Getter untuk memformat harga menjadi format mata uang Rupiah (contoh: Rp 15.000)
  String get formattedHarga {
    final str = harga.toString();
    final regExp = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return 'Rp ${str.replaceAllMapped(regExp, (match) => '${match[1]}.')}';
  }

  /// Getter nama_barang untuk menjaga kompatibilitas jika ada kode lama yang memanggilnya
  // ignore: non_constant_identifier_names
  String get nama_barang => nama;
}

/// Alias typedef agar kode yang menggunakan nama Item maupun Barang dapat berjalan dengan baik
typedef Item = Barang;