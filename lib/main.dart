import 'package:flutter/material.dart';
import 'package:pml/services/local_storage_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Challenge - Persistensi Data',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Panggil service yang sudah kita buat
  final LocalStorageService _storageService = LocalStorageService();

  int _counter = 0;
  String _secureResult = 'Belum ada data secure storage';
  final TextEditingController _tokenController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initAppData();
  }

  // Mengambil data counter saat aplikasi pertama kali dibuka
  Future<void> _initAppData() async {
    int savedCounter = await _storageService.getAppCounter();
    setState(() {
      _counter = savedCounter + 1;
    });
    // Simpan kembali counter yang bertambah
    await _storageService.saveAppCounter(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Challenge - Alvin'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info Counter SharedPreferences
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'SharedPreferences Counter',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Aplikasi telah dibuka sebanyak: $_counter kali',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Bagian Secure Storage Token
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Flutter Secure Storage',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _tokenController,
                      decoration: const InputDecoration(
                        labelText: 'Masukkan Token Rahasia',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await _storageService.saveUserToken(
                              _tokenController.text,
                            );
                            setState(() {
                              _secureResult =
                                  'Token berhasil disimpan secara aman!';
                            });
                          },
                          child: const Text('Simpan Token'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            String? token = await _storageService
                                .getUserToken();
                            setState(() {
                              _secureResult =
                                  'Token dibaca: ${token ?? "Kosong"}';
                            });
                          },
                          child: const Text('Baca Token'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Status: $_secureResult',
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
