class Pizza {
  int? id;
  String? pizzaName;
  String? description;
  double? price;
  String? imageUrl;
  String? size;

  // Constructor untuk membuat objek Pizza
  Pizza({
    this.id,
    this.pizzaName,
    this.description,
    this.price,
    this.imageUrl,
    this.size,
  });

  // Mengubah JSON menjadi objek Pizza dengan parsing aman
  Pizza.fromJson(Map<String, dynamic> json) {
    // Parsing ID dengan aman
    final idValue = json['id'];
    if (idValue is int) {
      id = idValue;
    } else {
      id = int.tryParse(idValue?.toString() ?? '');
    }

    // Membaca string dengan aman, menghindari nilai null
    pizzaName = json['pizzaName']?.toString();
    description = json['description']?.toString();
    imageUrl = json['imageUrl']?.toString();
    size = json['size']?.toString();

    // Parsing harga dengan aman, menerima int, double, atau String
    final priceValue = json['price'];
    if (priceValue is num) {
      price = priceValue.toDouble();
    } else {
      price = double.tryParse(priceValue?.toString() ?? '');
    }
  }

  // Mengubah objek Pizza menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pizzaName': pizzaName,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'size': size,
    };
  }
}
