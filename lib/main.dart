import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pml/model/pizza.dart';

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
  // State untuk Praktikum 1 - 3 (JSON)
  List<Pizza> myPizzas = [];

  // State untuk Praktikum 4 (SharedPreferences)
  int appCounter = 0;

  @override
  void initState() {
    super.initState();
    // Membaca file JSON dari assets (Praktikum 1 - 3)
    readJsonFile().then((value) {
      setState(() {
        myPizzas = value;
      });
    });

    // Membaca dan menulis SharedPreferences (Praktikum 4)
    readAndWritePreference();
  }

  // --- PRAKTIKUM 1, 2, 3: Membaca dan Konversi JSON ---
  Future<List<Pizza>> readJsonFile() async {
    String myString = await DefaultAssetBundle.of(context)
        .loadString('assets/pizzalist.json');
    List pizzaMapList = jsonDecode(myString);
    List<Pizza> loadedPizzas = [];
    for (var pizza in pizzaMapList) {
      Pizza myPizza = Pizza.fromJson(pizza);
      loadedPizzas.add(myPizza);
    }

    // Mengonversi kembali ke JSON String (tercetak di Debug Console)
    String json = convertToJSON(loadedPizzas);
    debugPrint('JSON Output: $json');

    return loadedPizzas;
  }

  String convertToJSON(List<Pizza> pizzas) {
    return jsonEncode(pizzas.map((pizza) => pizza.toJson()).toList());
  }

  // --- PRAKTIKUM 4: SHARED PREFERENCES ---
  Future<void> readAndWritePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = prefs.getInt('appCounter') ?? 0;
    counter++;
    await prefs.setInt('appCounter', counter);
    setState(() {
      appCounter = counter;
    });
  }

  Future<void> deletePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      appCounter = 0;
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
            // Bagian Tampilan Praktikum 4 (SharedPreferences Counter)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(
                      'You have opened the app $appCounter times.',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: deletePreference,
                      child: const Text('Reset counter'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Bagian Tampilan Praktikum 1 - 3 (ListView Pizza)
            const Text(
              'Daftar Menu Pizza',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: myPizzas.length,
              itemBuilder: (context, index) {
                final pizza = myPizzas[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${pizza.id}')),
                    title: Text('${pizza.pizzaName} (\$${pizza.price})'),
                    subtitle: Text(pizza.description),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
