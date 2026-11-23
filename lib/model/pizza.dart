class Pizza {
  int? id;
  String? pizzaName;
  String? description;
  double? price;
  String? imageUrl;
  String? size; // Field baru: ukuran pizza

  // Constructor Pizza
  Pizza({
    this.id,
    this.pizzaName,
    this.description,
    this.price,
    this.imageUrl,
    this.size,
  });

  // Mengubah JSON menjadi objek Pizza
  Pizza.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id'].toString());
    pizzaName = json['pizzaName'];
    description = json['description'];
    price = double.tryParse(json['price'].toString());
    imageUrl = json['imageUrl'];
    size = json['size'];
  }

  // Mengubah objek Pizza menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pizzaName': pizzaName,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'size': size, // Field size ikut dikirim ke JSON
    };
  }
}