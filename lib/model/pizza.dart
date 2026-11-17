// Konstanta kunci JSON untuk mencegah kesalahan penulisan (typo) string literal
const String keyId = 'id';
const String keyName = 'pizzaName';
const String keyDescription = 'description';
const String keyPrice = 'price';
const String keyImage = 'imageUrl';

class Pizza {
  final int id;
  final String pizzaName;
  final String description;
  final double price;
  final String imageUrl;

  Pizza({
    required this.id,
    required this.pizzaName,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  // Factory constructor untuk parsing JSON secara aman (Type-safe & fallback value)
  factory Pizza.fromJson(Map<String, dynamic> json) {
    return Pizza(
      // Menggunakan tryParse agar tidak crash jika data berupa string atau null
      id: int.tryParse(json[keyId]?.toString() ?? '') ?? 0,
      pizzaName: json[keyName]?.toString() ?? 'Nama Pizza Tidak Tersedia',
      description: json[keyDescription]?.toString() ?? 'Tidak ada deskripsi',
      // Mengatasi data harga tidak konsisten (misal: "mahal" -> 0.0)
      price: double.tryParse(json[keyPrice]?.toString() ?? '') ?? 0.0,
      imageUrl: json[keyImage]?.toString() ?? '',
    );
  }

  // Konversi objek Pizza kembali ke format Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      keyId: id,
      keyName: pizzaName,
      keyDescription: description,
      keyPrice: price,
      keyImage: imageUrl,
    };
  }
}