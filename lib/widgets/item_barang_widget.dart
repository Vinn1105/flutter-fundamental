import 'package:flutter/material.dart';
import 'package:pml/domain/barang.dart'; // Sesuaikan import model Barang Anda

class ItemBarangWidget extends StatelessWidget {
  final Barang barang;

  const ItemBarangWidget({super.key, required this.barang});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/detail', arguments: barang);
      },
      child: Container(
        color: Colors.tealAccent,
        margin: EdgeInsets.symmetric(vertical: 3),
        padding: EdgeInsets.all(5),
        child: Text(barang.nama_barang),
      ),
    );
  }
}