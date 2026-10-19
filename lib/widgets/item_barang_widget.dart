import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pml/domain/barang.dart';

// Widget khusus untuk menampilkan satu item barang
class ItemBarangWidget extends StatelessWidget {
  final Barang barang; // Menerima data barang yang akan ditampilkan

  const ItemBarangWidget({super.key, required this.barang});

  @override
  Widget build(BuildContext context) {
    // Mendeteksi sentuhan/klik pada item
    return GestureDetector(
      onTap: () {
        context.go('/detail/${barang.id}');
      },
      // Tampilan visual/desain kotak untuk setiap barang
      child: Container(
        color: Colors.tealAccent,
        margin: const EdgeInsets.symmetric(vertical: 3), // Jarak atas-bawah antar item
        padding: const EdgeInsets.all(5), // Jarak di dalam kotak item
        child: Text(barang.nama_barang), // Menampilkan nama barang
      ),
    );
  }
}