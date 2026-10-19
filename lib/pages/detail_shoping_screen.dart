import 'package:flutter/material.dart';
import 'package:pml/data/barang.dart';
import 'package:pml/domain/barang.dart';

class DetailShopingScreen extends StatelessWidget {
  final String id;
  const DetailShopingScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    // Menerima data 'barang' yang dikirim dari halaman sebelumnya melalui argumen navigasi
    final barang = list_barang.firstWhere(
      (barang) => barang.id.toString() == id,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Shopping"),
        backgroundColor: Colors.blue,
      ),
      // Container sebagai wadah utama dengan jarak/padding 20 di semua sisi
      body: Container(
        padding: const EdgeInsets.all(20),
        // Menampilkan nama barang yang diterima dari argumen
        child: Text(barang.nama_barang),
      ),
    );
  }
}