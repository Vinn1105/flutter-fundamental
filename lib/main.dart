import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Persistensi Data - Alvin',
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
  // State untuk Path Provider (Praktikum 5)
  String documentsPath = '';
  String tempPath = '';

  // State untuk File Storage (Praktikum 6)
  final TextEditingController _fileController = TextEditingController();
  String fileContent = '';

  // State untuk Secure Storage (Praktikum 7)
  final TextEditingController _secureKeyController = TextEditingController();
  final TextEditingController _secureValueController = TextEditingController();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String secureResult = '';

  @override
  void initState() {
    super.initState();
    getPaths();
    readFile();
  }

  // --- PRAKTIKUM 5: PATH PROVIDER ---
  Future<void> getPaths() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final tempDirectory = await getTemporaryDirectory();
    setState(() {
      documentsPath = documentsDirectory.path;
      tempPath = tempDirectory.path;
    });
  }

  // --- PRAKTIKUM 6: FILE STORAGE ---
  Future<File> get _localFile async {
    final path = documentsPath;
    return File('$path/file_praktikum6.txt');
  }

  Future<void> writeFile(String text) async {
    final file = await _localFile;
    await file.writeAsString(text);
  }

  Future<void> readFile() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        String contents = await file.readAsString();
        setState(() {
          fileContent = contents;
        });
      }
    } catch (e) {
      // Ignored
    }
  }

  // --- PRAKTIKUM 7: SECURE STORAGE ---
  Future<void> writeSecureData(String key, String value) async {
    await secureStorage.write(key: key, value: value);
  }

  Future<void> readSecureData(String key) async {
    String? value = await secureStorage.read(key: key);
    setState(() {
      secureResult = value ?? 'Data tidak ditemukan';
    });
  }

  Future<void> deleteSecureData(String key) async {
    await secureStorage.delete(key: key);
    setState(() {
      secureResult = 'Data berhasil dihapus';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Persistensi Data - Alvin'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- BAGIAN PRAKTIKUM 5: PATH PROVIDER ---
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Path Provider (Praktikum 5)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('Doc Path:\n$documentsPath', style: const TextStyle(fontSize: 12)),
                    const SizedBox(height: 8),
                    Text('Temp Path:\n$tempPath', style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- BAGIAN PRAKTIKUM 6: FILE STORAGE ---
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('File Storage (Praktikum 6)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _fileController,
                      decoration: const InputDecoration(labelText: 'Tulis teks untuk file', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        writeFile(_fileController.text);
                        readFile();
                      },
                      child: const Text('Simpan File'),
                    ),
                    const SizedBox(height: 8),
                    Text('Isi file: "$fileContent"', style: const TextStyle(fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- BAGIAN PRAKTIKUM 7: SECURE STORAGE ---
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Secure Storage (Praktikum 7)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _secureKeyController,
                      decoration: const InputDecoration(labelText: 'Key (Contoh: username)', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _secureValueController,
                      decoration: const InputDecoration(labelText: 'Value (Contoh: alvin123)', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => writeSecureData(_secureKeyController.text, _secureValueController.text),
                          child: const Text('Simpan'),
                        ),
                        ElevatedButton(
                          onPressed: () => readSecureData(_secureKeyController.text),
                          child: const Text('Baca'),
                        ),
                        ElevatedButton(
                          onPressed: () => deleteSecureData(_secureKeyController.text),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red[100]),
                          child: const Text('Hapus'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('Hasil Baca Secure: $secureResult', style: const TextStyle(fontWeight: FontWeight.bold)),
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