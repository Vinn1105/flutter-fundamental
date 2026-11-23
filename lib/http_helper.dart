
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model/pizza.dart';

class HttpHelper {
  // Singleton: menyimpan satu instance HttpHelper
  // agar bisa digunakan bersama di seluruh aplikasi.
  static final HttpHelper _instance = HttpHelper._internal();

  // Factory Method: mengembalikan instance yang sudah ada,
  // bukan membuat objek HttpHelper baru setiap pemanggilan.
  factory HttpHelper() {
    return _instance;
  }

  // Private constructor: mencegah pembuatan instance
  // secara langsung dari luar class.
  HttpHelper._internal();

  // URL utama server REST API WireMock.
  final String baseUrl = "https://zmk36q.wiremockapi.cloud";

  // Path endpoint untuk mengambil daftar dan detail pizza.
  final String path = "pizzalist";

  // Header untuk memberi tahu server bahwa data dikirim dalam format JSON.
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  // ========================= GET LIST PIZZA =========================

  // Mengambil seluruh data pizza dari server.
  // Jika request berhasil, JSON diubah menjadi List<Pizza>.
  // Jika terjadi error, mengembalikan list kosong.
  Future<List<Pizza>> getPizzaList() async {
    try {
      final url = Uri.parse("$baseUrl/$path");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        return data.map((item) => Pizza.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // ========================= GET DETAIL PIZZA =========================

  // Mengambil detail pizza berdasarkan ID.
  // Jika status 200, data JSON diubah menjadi objek Pizza.
  // Jika gagal, exception akan dilempar.
  Future<Pizza> getPizzaByID(String id) async {
    try {
      final url = Uri.parse("$baseUrl/$path/$id");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return Pizza.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          "Gagal mengambil detail pizza: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Error getPizzaByID: $e");
    }
  }

  // ========================= POST PIZZA =========================

  // Menambahkan pizza baru ke server menggunakan HTTP POST.
  // Data objek Pizza diubah menjadi JSON sebelum dikirim.
  // Status 200 atau 201 dianggap berhasil.
  Future<String> postPizza(Pizza pizza) async {
    try {
      final url = Uri.parse("$baseUrl/pizza");

      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(pizza.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      } else {
        throw Exception(
          "Gagal menambahkan pizza: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Error postPizza: $e");
    }
  }

  // ========================= PUT PIZZA =========================

  // Memperbarui data pizza yang sudah ada menggunakan HTTP PUT.
  // Data pizza dikirim dalam format JSON ke server.
  // Status 200 atau 201 dianggap berhasil.
  Future<String> putPizza(Pizza pizza) async {
    try {
      final url = Uri.parse("$baseUrl/pizza");

      final response = await http.put(
        url,
        headers: headers,
        body: json.encode(pizza.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      } else {
        throw Exception(
          "Gagal memperbarui pizza: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Error putPizza: $e");
    }
  }

  // ========================= DELETE PIZZA =========================

  // Menghapus data pizza menggunakan HTTP DELETE.
  // Data pizza dikirim ke server dalam format JSON.
  // Status 200 atau 201 dianggap berhasil.
  Future<String> deletePizza(Pizza pizza) async {
    try {
      final url = Uri.parse("$baseUrl/pizza");

      final response = await http.delete(
        url,
        headers: headers,
        body: json.encode(pizza.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      } else {
        throw Exception(
          "Gagal menghapus pizza: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Error deletePizza: $e");
    }
  }
}
