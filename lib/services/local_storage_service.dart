import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pml/model/pizza.dart';

class LocalStorageService {
  // Konstanta kunci penyimpanan
  static const String _counterKey = 'appCounter';
  static const String _tokenKey = 'userAuthToken';
  static const String _pizzaFileName = 'pizzalist_saved.json';

  // Instance FlutterSecureStorage
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // ==========================================
  // 1. SHARED PREFERENCES (App Counter)
  // ==========================================
  Future<void> saveAppCounter(int count) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_counterKey, count);
    } catch (e) {
      debugPrint('Gagal menyimpan counter: $e');
    }
  }

  Future<int> getAppCounter() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_counterKey) ?? 0;
    } catch (e) {
      debugPrint('Gagal membaca counter: $e');
      return 0;
    }
  }

  // ==========================================
  // 2. FILE STORAGE (Path Provider + dart:io)
  // ==========================================
  Future<File> _getLocalPizzaFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_pizzaFileName');
  }

  Future<void> writePizzaFile(List<Pizza> pizzas) async {
    try {
      final file = await _getLocalPizzaFile();
      final String jsonString = jsonEncode(pizzas.map((p) => p.toJson()).toList());
      await file.writeAsString(jsonString);
    } catch (e) {
      debugPrint('Gagal menulis file pizza: $e');
    }
  }

  Future<List<Pizza>> readPizzaFile() async {
    try {
      final file = await _getLocalPizzaFile();
      if (!await file.exists()) {
        return [];
      }
      final String contents = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(contents);
      return jsonList.map((json) => Pizza.fromJson(json)).toList();
    } catch (e) {
      // Menangani edge case jika file JSON rusak/korup (broken JSON)
      debugPrint('Error membaca/parsing file pizza (JSON rusak): $e');
      return [];
    }
  }

  // ==========================================
  // 3. SECURE STORAGE (User Token)
  // ==========================================
  Future<void> saveUserToken(String token) async {
    try {
      await _secureStorage.write(key: _tokenKey, value: token);
    } catch (e) {
      debugPrint('Gagal menyimpan token aman: $e');
    }
  }

  Future<String?> getUserToken() async {
    try {
      return await _secureStorage.read(key: _tokenKey);
    } catch (e) {
      debugPrint('Gagal membaca token aman: $e');
      return null;
    }
  }
}