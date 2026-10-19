import 'package:flutter/material.dart';

/// Widget pembantu untuk menampilkan gambar produk, mendukung URL internet maupun Asset lokal.
/// Dilengkapi dengan loading indicator dan tampilan fallback jika gambar gagal dimuat.
class ProductImageWidget extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;

  const ProductImageWidget({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final bool isNetwork = imagePath.startsWith('http://') || imagePath.startsWith('https://');

    if (isNetwork) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: Colors.grey.shade100,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackContainer();
        },
      );
    } else {
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackContainer();
        },
      );
    }
  }

  /// Tampilan cadangan jika gambar offline/tidak ditemukan
  Widget _buildFallbackContainer() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 36, color: Colors.grey.shade400),
            const SizedBox(height: 4),
            Text(
              'Gambar Produk',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}
