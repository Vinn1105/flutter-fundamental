import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pml/model/pizza.dart';

class HttpHelper {
  final String baseUrl = "https://zmk36q.wiremockapi.cloud";
  final String path = "pizzalist";

  // GET: Mengambil semua data pizza
  Future<List<Pizza>> getPizzaList() async {
    final url = Uri.parse("$baseUrl/$path");
    final result = await http.get(url);

    if (result.statusCode == 200) {
      final decoded = json.decode(result.body) as List<dynamic>;

      return decoded
          .map((pizza) => Pizza.fromJson(pizza as Map<String, dynamic>))
          .toList();
    }

    return [];
  }

  // GET: Mengambil detail pizza berdasarkan ID
  Future<Pizza> getPizzaByID(String id) async {
    final url = Uri.parse("$baseUrl/$path/$id");
    final result = await http.get(url);

    if (result.statusCode == 200) {
      final decoded = json.decode(result.body) as Map<String, dynamic>;
      return Pizza.fromJson(decoded);
    }

    throw Exception("Gagal get pizza by id");
  }

  // POST: Membuat pizza baru
  Future<String> postPizza(Pizza pizza) async {
    const postPath = '/pizza';
    final post = json.encode(pizza.toJson());
    final url = Uri.parse("$baseUrl$postPath");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: post,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }

    throw Exception("Gagal POST Pizza. Status code: ${response.statusCode}");
  }

  // PUT: Memperbarui data pizza
  Future<String> putPizza(Pizza pizza) async {
    const putPath = '/pizza';
    final put = json.encode(pizza.toJson());
    final url = Uri.parse("$baseUrl$putPath");

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: put,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }

    throw Exception("Gagal PUT Pizza. Status code: ${response.statusCode}");
  }

  // DELETE: Menghapus pizza
  Future<String> deletePizza(Pizza pizza) async {
    const deletePath = '/pizza';
    final url = Uri.parse("$baseUrl$deletePath");

    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(pizza.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }

    throw Exception("Gagal DELETE Pizza. Status code: ${response.statusCode}");
  }
}
