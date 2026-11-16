import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pml/model/pizza.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Persistensi Data - Praktikum 1-3',
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

  @override
  void initState() {
    super.initState();
    // Membaca file JSON dari assets (Praktikum 1 - 3)
    readJsonFile().then((value) {
      setState(() {
        myPizzas = value;
      });
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Persistensi Data - Praktikum 1-3'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
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
    );
  }
}