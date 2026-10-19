import 'package:flutter/material.dart';
import 'package:pml/data/barang.dart';
import 'package:pml/widgets/item_barang_widget.dart'; // Impor widget baru Anda

class ShopingScreen extends StatelessWidget {
  const ShopingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping List"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: list_barang.length,
          itemBuilder: (context, index) {
            final barang = list_barang[index];

            // Panggil widget yang sudah dipindah ke folder widgets
            return ItemBarangWidget(barang: barang);
          },
        ),
      ),
    );
  }
}