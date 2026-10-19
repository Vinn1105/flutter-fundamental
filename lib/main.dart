import 'package:flutter/material.dart';
import 'package:pml/pages/detail_shoping_screen.dart';
import 'package:pml/pages/shoping_screen.dart';

void main() {
  runApp(const MyApp());
}

/// Root widget aplikasi Belanja / Marketplace
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Katalog Belanja',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          primary: Colors.teal.shade700,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      // Navigasi rute awal aplikasi
      initialRoute: '/',
      // Registrasi rute aplikasi sesuai navigasi standar Flutter
      routes: {
        '/': (context) => const ShopingScreen(),
        '/detail': (context) => const DetailShopingScreen(),
      },
    );
  }
}
