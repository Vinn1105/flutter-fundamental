import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pml/pages/shoping_screen.dart';
import 'package:pml/pages/detail_shoping_screen.dart';

void main() {
  runApp(const MyApp()); // Menjalankan aplikasi Flutter
}

// Konfigurasi GoRouter untuk navigasi
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, _) => const ShopingScreen(),
      routes: [
        GoRoute(
          path: 'detail/:id', // Sub-route tidak menggunakan '/' di awal
          builder: (context, state) =>  DetailShopingScreen(id: state.pathParameters!['id']!),
        ),
      ],
    ),
  ],
); // Menggunakan titik koma (;) bukan koma (,)

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan MaterialApp.router agar GoRouter berfungsi
    return MaterialApp.router(
      routerConfig: _router, // Menghubungkan konfigurasi router
      title: 'Flutter Demo',
      // Mengatur tema warna utama aplikasi
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}