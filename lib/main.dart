import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

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

  // State untuk Praktikum 6 (Menulis dan Membaca File teks)
  final TextEditingController _controller = TextEditingController();
  String fileContent = '';

  @override
  void initState() {
    super.initState();
    getPaths();
    readFile(); // Membaca file saat aplikasi dibuka
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

  // --- PRAKTIKUM 6: MENULIS DAN MEMBACA FILE ---
  Future<File> get _localFile async {
    final path = await documentsPath;
    return File('$path/file_praktikum6.txt');
  }

  Future<File> writeFile(String text) async {
    final file = await _localFile;
    return file.writeAsString(text);
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
      // Handle error jika file belum ada
    }
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
                    const Text(
                      'Path Provider (Praktikum 5)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text('Doc Path:\n$documentsPath', style: const TextStyle(fontSize: 12)),
                    const SizedBox(height: 8),
                    Text('Temp Path:\n$tempPath', style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- BAGIAN PRAKTIKUM 6: READ/WRITE FILE ---
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'File Storage (Praktikum 6)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        labelText: 'Tulis sesuatu untuk disimpan',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        writeFile(_controller.text);
                        readFile();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Data berhasil disimpan ke file!')),
                        );
                      },
                      child: const Text('Simpan ke File'),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Isi file yang tersimpan:\n"$fileContent"',
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