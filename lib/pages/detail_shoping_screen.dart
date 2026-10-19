import 'package:flutter/material.dart';
import 'package:pml/domain/barang.dart';

class DetailShopingScreen extends StatelessWidget {
  const DetailShopingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final barang = ModalRoute.of(context)!.settings.arguments as Barang;

    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Shopping"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Text(barang.nama_barang),
      ),
    );
  }
}
