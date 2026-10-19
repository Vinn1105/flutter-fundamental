import 'package:flutter/material.dart';
import 'package:pml/domain/barang.dart';
import 'package:pml/widgets/item_card_widget.dart';

/// Kompatibilitas untuk ItemBarangWidget yang mengarahkan ke ItemCardWidget.
class ItemBarangWidget extends StatelessWidget {
  final Barang barang;

  const ItemBarangWidget({super.key, required this.barang});

  @override
  Widget build(BuildContext context) {
    return ItemCardWidget(barang: barang);
  }
}