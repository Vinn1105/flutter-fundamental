import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pml/domain/barang.dart';
import 'package:pml/widgets/product_image_widget.dart';

/// Widget kartu item bergaya marketplace untuk menampilkan ringkasan produk di GridView.
/// Membungkus gambar dengan widget Hero untuk transisi animasi halus ke halaman detail.
class ItemCardWidget extends StatelessWidget {
  final Barang barang;

  const ItemCardWidget({
    super.key,
    required this.barang,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: InkWell(
        // Navigasi ke halaman detail menggunakan GoRouter yang kompatibel dengan rute /detail/:id
        onTap: () {
          try {
            context.go('/detail/${barang.id}', extra: barang);
          } catch (_) {
            Navigator.pushNamed(
              context,
              '/detail',
              arguments: barang,
            );
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Gambar Produk dibungkus widget Hero dengan tag unik berbasis id barang
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Hero(
                      tag: 'barang-image-${barang.id}',
                      child: ProductImageWidget(
                        imagePath: barang.foto,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Badge Rating di atas gambar
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 3),
                          Text(
                            barang.rating.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bagian Informasi Produk (Nama, Harga, Stok)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Produk (maksimal 2 baris)
                  Text(
                    barang.nama,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Harga Produk
                  Text(
                    barang.formattedHarga,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Informasi Stok
                  Row(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 13,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Stok: ${barang.stok}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
