import 'package:flutter/material.dart';
import 'package:pml/data/barang.dart';
import 'package:pml/widgets/footer_widget.dart';
import 'package:pml/widgets/item_card_widget.dart';

/// Halaman utama katalog belanja.
/// Menggunakan GridView.builder 2 kolom ala marketplace dan dilengkapi dengan Footer identitas mahasiswa.
class ShopingScreen extends StatelessWidget {
  const ShopingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "Katalog Belanja",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur pencarian segera hadir')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Keranjang belanja masih kosong')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Bagian GridView daftar barang
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: listBarang.length,
                  // Mengatur layout Grid menjadi 2 kolom ala marketplace
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 kolom
                    childAspectRatio: 0.72, // Rasio lebar terhadap tinggi kartu
                    crossAxisSpacing: 10, // Jarak horizontal antar kartu
                    mainAxisSpacing: 10, // Jarak vertikal antar kartu
                  ),
                  itemBuilder: (context, index) {
                    final barang = listBarang[index];
                    // Menggunakan widget kartu modular ItemCardWidget
                    return ItemCardWidget(barang: barang);
                  },
                ),
              ),
            ),

            // Footer identitas mahasiswa di bagian bawah halaman utama
            const FooterWidget(),
          ],
        ),
      ),
    );
  }
}